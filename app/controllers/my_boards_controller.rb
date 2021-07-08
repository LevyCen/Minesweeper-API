class MyBoardsController < ApplicationController

    rescue_from Exception do |e|
        render json: {error: e.message}, status: :internal_server_error
    end
  
    rescue_from ActiveRecord::RecordInvalid do |e|
        render json: {error: e.message}, status: :unprocessable_entity
    end
  
    rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {error: e.message}, status: :not_found
    end

    #GET /myboards/{id}
    def show
        @my_boards = Board.where(user_id: params[:id]).where(enabled: true).order('created_at') 
        #puts "yes: #{params}"
        render json:@my_boards, status: :ok
    end

    #POST /newgame
    def create
        @my_board = Board.new(board_params)
        if @my_board.save
            create_square(@my_board.height,
                        @my_board.width,
                        @my_board.id)
            
            add_mines(@my_board.id,@my_board.mines,)

            set_squares_values(@my_board)
            
            
            @squares_board = Square.where(board_id: @my_board.id)

            render json:@squares_board, status: :ok

        else
            render json:@my_board.errors, status: :unprocessable_entity
        end
    end


    #DELETE /myboards
    def destroy
        @my_boards = Board.where(user_id: params[:user_id]).where(id: params[:board_id]).first
        # puts "yes: #{params}"
        # puts "object: #{@my_boards.to_s}"

        if @my_boards.present?
            if @my_boards.destroy
                render json: {
                    status: 'successful',
                    message: 'board destroyed',
                    data: @my_boards
                },status: :ok
            else 
                render json:@my_boards.errors, status: :unprocessable_entity
            end
        else
            render json: {
                status: 'fail',
                message: 'board not found',
            },status: :not_found
        end
        # render json:@my_boards, status: :ok
    end

    private
    # Deben ser los mismos parametros que definimos como required
    def board_params
        params.permit(:name,:height,:width,:enabled, :mines, :user_id)
    end

    def create_square(height,width, board_id)
        for row in 0..height-1 do
            for column in 0..width-1 do
                @square = Square.new({
                    "row" => row,
                    "column" => column,
                    "value" => 0,
                    "mine" => false,
                    "open" => false,
                    "board_id" => board_id
                })
               
                if @square.save
                    #continue
                else
                    render json:@square.errors, status: :unprocessable_entity
                end
            end
        end
    
    end

    def square_params
        params.permit(:row, :column, :value, :mine, :open, :board_id)
    end

    # add mines to board
    def add_mines(board_id,number_mines)
        board_squares = Square.where(board_id: board_id)
        
        mines_added = 0
        num_max = board_squares.size-1
        while mines_added < number_mines
            square_mine = rand(0..num_max)
            unless board_squares[square_mine].mine
                board_squares[square_mine].update(mine: true)
                mines_added += 1
            end 
        end
        
    end

    #set values to squares
    def set_squares_values(board)
        board_id = board.id
        board_height = board.height
        board_width = board.width

        boards_squares = Square.where(board_id: board_id, mine: false)
        all_boards_squares = Square.where(board_id: board_id)
        
        board_mines = Square.where(board_id: board_id, mine: true)

        for k in 0..board_mines.size-1 do puts "minas en #{board_mines[k].row} #{board_mines[k].column} " end
            
        for iteration in 0..boards_squares.size-1 do
            coordinates_list = get_coordinates_arround(board_height,
                board_width,
                boards_squares[iteration].row,
                boards_squares[iteration].column)
            square_value = generate_square_value(all_boards_squares,coordinates_list)
            boards_squares[iteration].update(value: square_value)
            puts "Coordenada [#{boards_squares[iteration].row},#{boards_squares[iteration].column}] se encontró el valor #{square_value} y se guardo #{boards_squares[iteration].value}"
        end

    end

    def get_coordinates_arround(board_height,board_width,row,column)

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
        puts coordinates_list.to_s
        return coordinates_list
    end

    # 
    def generate_square_value(boards_squares,coordinates_list)
        count_mines = 0
        for i in 0..(coordinates_list.size-1) do
            if boards_squares.find{|b| b.row == coordinates_list[i][0] && b.column == coordinates_list[i][1] }.mine
                count_mines += 1
            end
        end
        return count_mines
    end 
end