class SquaresService

    def initialize(input_boards_squares, input_board)
        @board_squares = input_boards_squares
        @board = input_board
        @board_height = @board.height
        @board_width = @board.width
    end

    def open_square(input_row,input_column)
        square_value = get_square_value(input_row,input_column)
        
        if square_value > 0 
            set_square_open(input_row, input_column)
        elsif square_value == 0 
            set_zero_square_open(input_row,input_column)
        end

        return true
    end

    def square_is_open?(input_row, input_column)
        if @board_squares.find_by(row: input_row, column: input_column).open
            return true
        else
            return false
        end
    end

    def square_is_closed?(input_row,input_column)
        if @board_squares.find_by(row: input_row, column: input_column).open
            return false
        else
            return true
        end
    end

    def get_square_value(input_row,input_column)
        return @board_squares.find_by(row: input_row, column: input_column).value
    end

    def square_is_mine?(input_row,input_column)
        return @board_squares.find_by(row: input_row, column: input_column).mine
    end

    def get_squares
        return @board_squares
    end

    def game_is_finised
        if @board_squares.where(mine: false, open: false).empty?
            return true
        else
            return false
        end
    end

    private
    
    def set_zero_square_open(input_row,input_column)

        list_zero_squares = Array.new()
        list_zero_squares.push(@board_squares.find_by(row: input_row, column: input_column))
        array_position = 0
        
        while array_position < list_zero_squares.size do
            
            # list_zero_squares[array_position].update({"open"=>true})
            zero_square = list_zero_squares[array_position]
            zero_square_row = zero_square.row
            zero_square_column = zero_square.column
            set_square_open(zero_square_row, zero_square_column)
            
            list_coordinates_arround = CoordinatesService.get_coordinates_arround(@board_height, @board_width, zero_square_row, zero_square_column)

            for value in 0..list_coordinates_arround.size-1 do
                row = list_coordinates_arround[value][0]
                column = list_coordinates_arround[value][1]

                square_value = get_square_value(row,column) 

                if square_value > 0
                    # open box
                    if square_is_closed?(row,column)
                        set_square_open(row,column)
                    end
                    puts array_position
                    
                elsif square_value == 0
                    # add square with value = 0 in  list_zero_squares
                    # if there are another boxes whit value = 0 then, apply the same procedure
                    if square_is_closed?(row,column)
                        list_zero_squares.push(@board_squares.find_by(row: row, column: column))
                    end
                    
                end                   
            end
            array_position += 1
        end
    end

    def set_square_open(input_row, input_column)
        @board_squares.find_by(row: input_row, column: input_column).update!({"open"=>true})
    end
end