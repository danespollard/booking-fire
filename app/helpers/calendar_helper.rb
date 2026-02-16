module CalendarHelper
  def openings_text(from, to)
    blocks = Current.user.availability_blocks.open.where(date: from..to).order(:date)
    return "No open dates." if blocks.empty?

    lines = blocks.map { |b| "  #{b.date.strftime("%a %b %-d")}" }
    "I'm available on:\n#{lines.join("\n")}"
  end

  def day_cell_classes(block)
    if block&.open?
      "bg-emerald-100"
    elsif block&.booked?
      "bg-rose-100"
    else
      "bg-gray-50"
    end
  end

  def day_status_label(block)
    if block&.open?
      content_tag(:span, "OPEN", class: "text-[10px] font-semibold text-emerald-700")
    elsif block&.booked?
      content_tag(:span, "BOOKED", class: "text-[10px] font-semibold text-rose-700")
    else
      content_tag(:span, "—", class: "text-gray-300")
    end
  end
end
