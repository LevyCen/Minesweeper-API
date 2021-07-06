require "byebug"

class MyBoardsController < ApplicationController

    # rescue_from Exception do |e|
    #     render json: {error: e.message}, status: :internal_server_error
    # end
  
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

    #POST /myboards
    def create
        @my_board = Board.new(board_params)
        @mines = 3
        if @my_board.save
            create_square(@my_board.height,
                        @my_board.width,
                        @my_board.id)
            add_mines(@my_board.id,@my_board.mines,)

            render json:@my_board, status: :ok
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
        num_max = board_squares.size
        while mines_added < number_mines
            square_mine = rand(0..num_max)
            unless board_squares[square_mine].mine
                board_squares[square_mine].update(mine: true)
                mines_added += 1
            end 
        end
        
    end

end