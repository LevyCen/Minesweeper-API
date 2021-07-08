class SquaresController < ApplicationController

    rescue_from Exception do |e|
        render json: {error: e.message}, status: :internal_server_error
    end
  
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
        break_flag = false
        
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
            if my_boards_squares.where(row: params[:row], column: params[:column]).first.open
                # las coordenadas son de una caja abierta? si son. entonces notificar caja abierta
                return render json: {
                    status: 'fail',
                    message: 'box was open',
                    data: my_boards_squares
                },status: :not_acceptable
                break_flag = true
                
            elsif my_boards_squares.where(row: params[:row], column: params[:column]).first.value > 0
                # si no, las coordenadas son de una caja con valor > a 0 ? si son. abrimos la caja
                my_boards_squares.where(row: params[:row], column: params[:column]).first.update({"open"=>true})
                
            elsif my_boards_squares.where(row: params[:row], column: params[:column]).first.value = 0
                # si no, las coordenadas son de una caja con valor = 0 ? si son. abrimos la caja 
                # y abrimos las cajas de al rededor con valor mayor a 0,
                my_board = Board.find(params[:board_id]) 
                value_zero_list = Array.new()
                value_zero_list.push(my_boards_squares.where(row: params[:row], column: params[:column]).first)
                array_position = 0
                
                while array_position < value_zero_list.size do
                    
                    value_zero_list[array_position].update({"open"=>true})
                    coordinates_list = CoordinatesService.get_coordinates_arround(my_board.height, my_board.width, value_zero_list[array_position].row, value_zero_list[array_position].column)


                    for value in 0..coordinates_list.size-1 do
                        if my_boards_squares.where(row: coordinates_list[value][0], column: coordinates_list[value][1]).first.value > 0
                            # open box
                            unless my_boards_squares.where(row: coordinates_list[value][0], column: coordinates_list[value][1]).first.open
                                my_boards_squares.where(row: coordinates_list[value][0], column: coordinates_list[value][1]).first.update({"open"=>true})
                            end
                        else
                            # save news box with value = 0
                            # if there are another box whit value = 0 then, apply the same procedure
                            unless my_boards_squares.where(row: coordinates_list[value][0], column: coordinates_list[value][1]).first.open
                                my_boards_squares.where(row: coordinates_list[value][0], column: coordinates_list[value][1]).first.update({"open"=>true})
                                value_zero_list.push(my_boards_squares.where(row: coordinates_list[value][0], column: coordinates_list[value][1]).first)
                            end
                        end                   
                    end
                    array_position += 1
                end
                

            else
                #error con las coordenas enviadas
                return render json: {
                    status: 'fail',
                    message: 'error with box',
                    data: my_boards_squares
                },status: :not_acceptable
                break_flag = true
            end

            if break_flag
            #return message
            else
                # al final se evalua si todas las que no son minas ya están abiertas
                if my_boards_squares.where(mine: false, open: false).empty?
                    #player won
                    render json: {
                        status: 'successful',
                        message: 'You are a winner',
                        data: my_boards_squares
                    },status: :ok
                else
                    #player won
                    render json: {
                        status: 'continue',
                        message: 'nice continue playing',
                        data: my_boards_squares
                    },status: :ok
                end
            end

        end
        

        
        
        
        
        

        
    end
end