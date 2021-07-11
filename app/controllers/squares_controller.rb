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
    def open_box
        # recuperar el tablero
        my_boards_squares =  Square.where(board_id: params[:board_id])
        flag_is_ok = true
        
        #validar las coordenadas son minas?
        if my_boards_squares.where(row: params[:row], column: params[:column]).first.mine
            # si son minas, game over
            @my_board = Board.find(params[:board_id])

            if @my_board.present?
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
                render json: {
                    status: 'fail',
                    message: 'board not found',
                },status: :not_found
            end

        else
            # si no son minas, continuamos
            square_open =  my_boards_squares.where(row: params[:row], column: params[:column]).first.open
            square_value = my_boards_squares.where(row: params[:row], column: params[:column]).first.value 

            if square_open
                # las coordenadas son de una caja abierta? si son. entonces notificar caja abierta
                return render json: {
                    status: 'fail',
                    message: 'box was open',
                    data: my_boards_squares
                },status: :not_acceptable
                flag_is_ok = false
                
            elsif square_value > 0
                # si no, las coordenadas son de una caja con valor > a 0 ? si son. abrimos la caja
                # = SquaresService(my_board)
                a = SquaresService.new()
                a.open_square(my_boards_squares,params[:row],params[:column])

            elsif square_value == 0
                # si no, las coordenadas son de una caja con valor = 0 ? si son. abrimos la caja 
                # y abrimos las cajas de al rededor con valor mayor a 0,
                a = SquaresService.new()
                a.open_square_value_zero(my_boards_squares,params[:row],params[:column],params[:board_id])

            else
                #error con las coordenas enviadas
                return render json: {
                    status: 'fail',
                    message: 'error with square',
                    data: my_boards_squares
                },status: :not_acceptable
                flag_is_ok = false
            end


            if flag_is_ok
                # se evalua si todas las que no son minas ya están abiertas

                if game_is_finised(my_boards_squares)
                    #player won
                    render json: {
                        status: 'successful',
                        message: 'You are a winner',
                        data: my_boards_squares
                    },status: :ok
                else
                    #player continue
                    render json: {
                        status: 'continue',
                        message: 'nice continue playing',
                        data: my_boards_squares
                    },status: :ok
                end
            end

        end
        
    end

    def game_is_finised(my_boards_squares)
        if my_boards_squares.where(mine: false, open: false).empty?
            return true
        else
            return false
        end

    end
end