class CoordinatesService
    def self.get_coordinates_arround(board_height,board_width,row,column)
        
        row_less = row - 1
        row_higher = row + 1
        column_less = column - 1
        column_higher = column + 1

        coordinates_list = Array.new()

        for row_ in row_less..row_higher do
            for column_ in column_less..column_higher do
                coo_list = Array.new()
                if column_ == column && row_ == row
                    #no add
                elsif row_ < 0 || column_ < 0
                    # fuera de tablero por arriba y por izquierda
                    #no add
                elsif  row_ >= board_height || column_ >= board_width
                    # fuera de tablero por abajo y por la dercha
                    #no add
                else 
                    coo_list.push(row_)
                    coo_list.push(column_)
                end

                unless coo_list.empty?
                    coordinates_list.push(coo_list)
                end
            end
        end
        
        return coordinates_list
    end
end