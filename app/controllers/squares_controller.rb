require 'byebug'

class SquaresController < ApplicationController

    # rescue_from Exception do |e|
    #     render json: {error: e.message}, status: :internal_server_error
    # end
  
    rescue_from ActiveRecord::RecordInvalid do |e|
        render json: {error: e.message}, status: :unprocessable_entity
    end
  
    rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {error: e.message}, status: :not_found
    end

    #POST /openbox
    def open_square
        # recuperar el tablero

        @my_board = Board.find(params[:board_id])
        @my_boards_squares =  Square.where(board_id: params[:board_id])
        row = params[:row]
        column = params[:column]

        if !@my_board.present?
            return render json: {
                status: 'fail',
                message: 'board not found',
            },status: :not_found
        end

        #validate params
        if !row_column_is_valid(row,column)
            return  render json: {
                status: 'fail',
                message: 'row or column is not valid',
            },status: :not_found
        end

        @my_game_board = SquaresService.new(@my_boards_squares, @my_board)
        flag_is_ok = true
        
        
        #validar las coordenadas son minas?
        if @my_game_board.square_is_mine?(row,column)
            # If is mine then game over
            # @my_board = Board.find(params[:board_id])   delete

            if @my_board.destroy
                render json: {
                    status: 'successful',
                    message: 'You lost',
                    data: @my_board
                },status: :ok
            else 
                render json:@my_board.errors, status: :unprocessable_entity
            end


        else
            # si no son minas, continuamos
            
            square_value = @my_game_board.get_square_value(row, column)

            if @my_game_board.square_is_open?(row, column)
                # las coordenadas son de una caja abierta? si son. entonces notificar caja abierta
                
                return render json: {
                    status: 'fail',
                    message: 'box was open',
                    data: @my_boards_squares
                },status: :not_acceptable
                flag_is_ok = false
                
            else
                # si no, las coordenadas son de una caja con valor > a 0 ? si son. abrimos la caja
                @my_game_board.open_square(row,column)
            end


            if flag_is_ok
                # se evalua si todas las que no son minas ya están abiertas

                if @my_game_board.game_is_finised
                    

                    if @my_board.destroy
                        #player won
                        render json: {
                            status: 'successful',
                            message: 'You are a winner',
                            data: @my_boards_squares
                        },status: :ok
                    else 
                        render json:@my_board.errors, status: :unprocessable_entity
                    end
                else
                    #player continue
                    render json: {
                        status: 'continue',
                        message: 'nice continue playing',
                        data: @my_boards_squares
                    },status: :ok
                end
            end

        end
        
    end

    private

    def row_column_is_valid(input_row, input_column)

        if input_row.to_i >= @my_board.height || input_row.to_i < 0
            return false
        elsif input_column.to_i  >= @my_board.width || input_column.to_i  < 0
            return false
        else
            return true
        end
    end
end