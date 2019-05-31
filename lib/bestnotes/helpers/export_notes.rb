require "prawn"

def export_notes(file_path, category_name, notes)

  Prawn::Document.generate(file_path) do |pdf|
    pdf.text "Category: #{category_name}", style: :bold, size: 16, align: :center

    sel_date = nil
    notes.each do |note|
      date_str = note[:creation_time].strftime("%d/%m/%Y")
      if date_str != sel_date
        sel_date = date_str
        pdf.move_down 10
        pdf.text "Added on: " + sel_date, style: :bold, size: 14
        pdf.move_down 5
      end
      pdf.text note[:id].to_s, style: :bold
      pdf.text note[:contents]
      pdf.move_down 5
    end
    pdf.text "Exported from BestNotes #{Time.now.strftime("%c")}.", valign: :bottom
  end

end