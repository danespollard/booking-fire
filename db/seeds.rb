user = User.find_or_create_by!(email_address: "test@example.com") do |u|
  u.password = "password"
end

Template::DEFAULTS.each do |attrs|
  user.templates.find_or_create_by!(name: attrs[:name]) do |t|
    t.body = attrs[:body]
    t.position = attrs[:position]
  end
end

user.templates.find_or_create_by!(name: "Wedding Planner") do |t|
  t.position = 3
  t.body = <<~BODY.strip
    Hi! Here's what I have open for weddings:
    {open_dates_list}

    Currently holding {hold_dates}. I'll let you know if anything frees up. Happy to send a quote for any of these.
  BODY
end

clubs = [
  "The Blue Room", "Copper Kettle Taproom", "Riverside Supper Club",
  "Maple Street Jazz Night", "Lantern Hall", "The Gilded Fox"
]
private_events = [
  "Halvorsen–Reyes wedding", "Okafor 40th birthday", "Brightwater Winery",
  "St. Brigid's Gala", "Delgado–Park wedding", "Harbor Point Yacht Club"
]
sundays = [
  "Copper Kettle Taproom brunch", "Brightwater Winery afternoon set",
  "Riverside Supper Club brunch", "Cedar Grove farmers market"
]
speaking = [
  "Northline Credit Union offsite", "Lakeview Library talk",
  "Cedar Valley Teachers Conference", "Summit Health leadership retreat"
]

rng = Random.new(2026)
today = Date.current
range = (today.prev_month.beginning_of_month)..(today >> 3).end_of_month

user.availability_blocks.where(date: range).delete_all

range.each do |date|
  roll = rng.rand
  upcoming = date >= today

  attrs =
    case date.wday
    when 5, 6
      if !upcoming || roll < 0.45
        venues = date.saturday? && rng.rand < 0.5 ? private_events : clubs
        { status: :booked, time_label: :evening, client_name: venues.sample(random: rng) }
      elsif roll < 0.6
        { status: :hold, time_label: :evening, client_name: private_events.sample(random: rng) }
      elsif roll < 0.9
        { status: :open, time_label: :evening }
      end
    when 4
      if roll < 0.3
        { status: :booked, time_label: :after_9pm, client_name: clubs.sample(random: rng) }
      elsif roll < 0.75 && upcoming
        { status: :open, time_label: :evening }
      end
    when 0
      if roll < 0.2
        { status: :booked, time_label: :daytime, client_name: sundays.sample(random: rng) }
      elsif roll < 0.5 && upcoming
        { status: :open, time_label: :daytime }
      end
    else
      if roll < 0.1
        { status: :booked, time_label: :daytime, client_name: speaking.sample(random: rng) }
      elsif roll < 0.15 && upcoming
        { status: :hold, time_label: :daytime, client_name: speaking.sample(random: rng) }
      elsif roll < 0.3 && upcoming
        { status: :open, time_label: :anytime }
      end
    end

  user.availability_blocks.create!(date: date, **attrs) if attrs
end
