module ImportData
  class PackagingWastes < Base

    attr_reader :street_col_inx, :street_no_col_inx, :description_col_inx, :clear_glass_col_inx, :colorful_glass_col_inx, :plastic_col_inx, :maculature_col_inx

    def import
      Waste.packaging_wastes.delete_all
      
      row = address_sheet.row(3)
      @street_col_inx = row.index('Ulica') + 1
      @street_no_col_inx = row.index('Numer(y)') + 1
      @description_col_inx = row.index('Opis') + 1
      @clear_glass_col_inx = row.index('szkło bezbarwne') + 1
      @colorful_glass_col_inx = row.index('szkło kolorowe') + 1
      @maculature_col_inx = row.index('makulatura') + 1
      @plastic_col_inx = row.index('tworzywo sztuczne') + 1

      (4..address_sheet.last_row).each do |row|
        waste = Waste.new(data(row))
        LogActivity.save(waste) unless waste.save
      end
    end

    private

    def address_sheet
      @sheet_addreses ||= excel.sheets.index {|sheet| sheet == 'spis lokalizacji - selektywna' }
      excel.sheet(@sheet_addreses)
    end

    def weekdays_sheet
      @sheet_weekdays ||= excel.sheets.index {|sheet| sheet == 'harmonogram - selektywna' }
      excel.sheet(@sheet_weekdays)
    end

    def street_cell(row)
      clean_street(address_sheet.cell(row, 3))
    end

    def numbers_cell(row)
      address_sheet.cell(row, 4)
    end

    def address_cell(row)
      [ street_cell(row), numbers_cell(row) ].compact.join(' ')
    end

    def data(row)
      {
        kind: 3,
        street: address_cell(row),
        data: {
          info: excel.cell(row, description_col_inx),
          weekday: {
            clear_glass:    [weekday(3, row)],
            colorful_glass: [weekday(4, row)],
            maculature:     [weekday(5, row)],
            plastic:        [weekday(6, row)]
          }
        }
      }
    end

    def weekday(waste_row, row)
      area = address_sheet.cell(row, 2).to_i
      (2..weekdays_sheet.last_column).each do |col|
        areas = weekdays_sheet.cell(waste_row, col)
        next if areas == '-'
        first, last = areas.split('-')
        return col - 1 if first.to_i >= area && area <= last.to_i
      end
      nil
    end
  end
end
