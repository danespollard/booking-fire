module CalendarHelper
  def openings_text(from, to)
    blocks = Current.user.availability_blocks.where(date: from..to).order(:date)
    open_blocks = blocks.select(&:open?)
    hold_blocks = blocks.select(&:hold?)

    parts = []

    if open_blocks.any?
      lines = open_blocks.map { |b| format_block_line(b) }
      parts << "I'm available on:\n#{lines.join("\n")}"
    end

    if hold_blocks.any?
      lines = hold_blocks.map { |b| format_block_line(b) }
      parts << "On hold:\n#{lines.join("\n")}"
    end

    return "No open dates." if parts.empty?

    parts.join("\n")
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

  def format_block_line(block)
    line = "  #{block.date.strftime("%a %b %-d")}"
    line += " (#{block.display_time_label})" if block.display_time_label
    line
  end
end
