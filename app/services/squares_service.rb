class SquaresService

    # def initialize(my_boards_squares)
    #     @boards_squares = my_boards_squares
    # end

    def open_square_value_zero(my_boards_squares,input_row,input_column,board_id)

        my_board = Board.find(board_id) 
        value_zero_list = Array.new()
        value_zero_list.push(my_boards_squares.where(row: input_row, column: input_column).first)
        array_position = 0
        
        while array_position < value_zero_list.size do
            
            value_zero_list[array_position].update({"open"=>true})
            list_coordinates_arround = CoordinatesService.get_coordinates_arround(my_board.height, my_board.width, value_zero_list[array_position].row, value_zero_list[array_position].column)

            for value in 0..list_coordinates_arround.size-1 do
                row = list_coordinates_arround[value][0]
                column = list_coordinates_arround[value][1]

                @square_value = square_value(my_boards_squares,row,column)

                if @square_value > 0
                    # open box
                    if square_is_closed(my_boards_squares,row,column)
                        open_square(my_boards_squares,row,column)
                    end
                elsif @square_value == 0
                    # save news box with value = 0
                    # if there are another boxes whit value = 0 then, apply the same procedure
                    if square_is_closed(my_boards_squares,row,column)
                        open_square(my_boards_squares,row,column)
                        value_zero_list.push(my_boards_squares.where(row: row, column: column).first)
                    end
                end                   
            end
            array_position += 1
        end
    end

    def open_square(my_boards_squares, input_row, input_column)
        my_boards_squares.where(row: input_row, column: input_column).first.update({"open"=>true})
    end

    def square_is_open(my_boards_squares, input_row, input_column)
        if my_boards_squares.where(row: input_row, column: input_column).first.open
            return true
        else
            return false
        end
    end

    def square_is_closed(my_boards_squares,input_row,input_column)
        if my_boards_squares.where(row: input_row, column: input_column).first.open
            return false
        else
            return true
        end
    end

    def square_value(my_boards_squares,input_row,input_column)
        return my_boards_squares.where(row: input_row, column: input_column).first.value
    end
end