module CalendarHelper
  def render_template(body, from, to)
    blocks = Current.user.availability_blocks.where(date: from..to).order(:date)
    open_blocks = blocks.select(&:open?)
    hold_blocks = blocks.select(&:hold?)
    booked_blocks = blocks.select(&:booked?)

    body
      .gsub("{open_dates}", open_dates_inline(open_blocks))
      .gsub("{open_dates_list}", dates_list(open_blocks))
      .gsub("{open_dates_grouped}", dates_grouped(open_blocks))
      .gsub("{hold_dates}", open_dates_inline(hold_blocks))
      .gsub("{hold_dates_list}", dates_list(hold_blocks))
      .gsub("{booked_dates}", booked_dates_inline(booked_blocks))
      .gsub("{booked_dates_list}", booked_dates_list(booked_blocks))
  end

  def day_cell_classes(block)
    if block&.open?
      "bg-emerald-100"
    elsif block&.booked?
      "bg-rose-100"
    elsif block&.hold?
      "bg-amber-200"
    else
      "bg-gray-50"
    end
  end

  def day_status_label(block)
    return content_tag(:span, "—", class: "text-gray-300") unless block

    parts = []

    case block.status
    when "open"
      parts << content_tag(:span, "OPEN", class: "text-[10px] font-semibold text-emerald-700")
    when "booked"
      parts << content_tag(:span, "BOOKED", class: "text-[10px] font-semibold text-rose-700")
    when "hold"
      parts << content_tag(:span, "HOLD", class: "text-[10px] font-semibold text-amber-700")
    end

    if block.display_time_label
      parts << content_tag(:span, block.display_time_label, class: "text-[9px] text-gray-500")
    end

    safe_join(parts, " ")
  end

  private

  def open_dates_inline(blocks)
    return "none" if blocks.empty?
    blocks.map { |b| format_inline(b) }.join(", ")
  end

  def dates_list(blocks)
    return "  (none)" if blocks.empty?
    blocks.map { |b| format_block_line(b) }.join("\n")
  end

  def dates_grouped(blocks)
    return "(none)" if blocks.empty?
    blocks.group_by { |b| b.date.strftime("%a") }.map do |day, day_blocks|
      dates = day_blocks.map { |b| b.date.strftime("%-m/%-d") }.join(", ")
      "#{day}: #{dates}"
    end.join("\n")
  end

  def format_inline(block)
    s = block.date.strftime("%a %-m/%-d")
    s += " (#{block.display_time_label})" if block.display_time_label
    s
  end

  def format_block_line(block)
    line = "  #{block.date.strftime("%a %b %-d")}"
    line += " (#{block.display_time_label})" if block.display_time_label
    line
  end

  def booked_dates_inline(blocks)
    return "none" if blocks.empty?
    blocks.map { |b| format_booked_inline(b) }.join(", ")
  end

  def booked_dates_list(blocks)
    return "  (none)" if blocks.empty?
    blocks.map { |b| format_booked_line(b) }.join("\n")
  end

  def format_booked_inline(block)
    s = block.date.strftime("%a %-m/%-d")
    s += " — #{block.client_name}" if block.client_name.present?
    s
  end

  def format_booked_line(block)
    line = "  #{block.date.strftime("%a %b %-d")}"
    line += " — #{block.client_name}" if block.client_name.present?
    line
  end
end
