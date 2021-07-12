# Minesweeper-API

This is a REST API for the minesweeper game 

## Software version
* Ruby version 2.7.1p83
* Rails version 6.1.4

## Functionalities
* Design and implementation of a documented RESTful API for the game (thought of a mobile application for the API).
* When a cell with no adjacent mines is revealed, all adjacent squares will be revealed (and repeated).
* Detect when the game ends
* Start a new game and preserve / resume old ones.
* Select game parameters: number of rows, columns and mines.

## Entity relation diagram

![Entity relation diagram](https://raw.githubusercontent.com/LevyCen/Minesweeper-API/master/image/entity_relationship_diagram.jpg)
 

# REST API
Examples to consume the REST API

## Register new user
`POST /users`

	curl -i -H 'Accept: application/json' -d 'email=levycen.d2@gmail.com&name=Levy Cen2&auth_token=xxxxxxx' http://fast-scrubland-04933.herokuapp.com/users

### Response

	HTTP/1.1 200 OK
	Server: Cowboy
	Date: Thu, 08 Jul 2021 04:07:26 GMT
	Connection: keep-alive
	Content-Type: application/json; charset=utf-8
	Vary: Accept
	{"id":2,"email":"levycen.d2@gmail.com","name":"Levy Cen2","auth_token":"xxxxxxx","created_at":"2021-07-08T04:07:27.616Z","updated_at":"2021-07-08T04:07:27.616Z"}%
	
## All users
`GET /users`

	curl -i -H 'Accept: application/json' http://fast-scrubland-04933.herokuapp.com/users

### Response

	HTTP/1.1 200 OK
	Server: Cowboy
	Date: Thu, 08 Jul 2021 04:00:54 GMT
	Connection: keep-alive
	Content-Type: application/json; charset=utf-8
	Vary: Accept
	{"status":"successful","message":"all user","data":[{"id":1,"email":"levycen.d@gmail.com","name":"Levy Cen","auth_token":"xxxxxxxxx","created_at":"2021-07-08T03:16:02.656Z","updated_at":"2021-07-08T03:16:02.656Z"}]}

## New game
`POST /newgame`

	curl -i -H 'Accept: application/json' -d 'name=Tablero&height=3&width=3&enabled=true&mines=3&user_id=2' http://fast-scrubland-04933.herokuapp.com/newgame

### Response

	HTTP/1.1 200 OK
	Server: Cowboy
	Date: Thu, 08 Jul 2021 04:16:41 GMT
	Connection: keep-alive
	Content-Type: application/json; charset=utf-8
	Vary: Accept
	[{"id":10,"row":0,"column":0,"value":1,"mine":false,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.479Z","updated_at":"2021-07-08T04:16:41.585Z"},... etc etc

## Show my games
`GET /myboards/{user_id}`

	curl -i -H 'Accept: application/json' http://fast-scrubland-04933.herokuapp.com/myboards/2

### Response

	HTTP/1.1 200 OK
    Server: Cowboy
    Date: Thu, 08 Jul 2021 04:22:08 GMT
    Connection: keep-alive
    Content-Type: application/json; charset=utf-8
    Vary: Accept
    [{"id":2,"name":"Tablero","height":3,"width":3,"enabled":true,"mines":3,"user_id":2,"created_at":"2021-07-08T04:16:41.443Z","updated_at":"2021-07-08T04:16:41.443Z"}]

## Open a box from board
`POST /square/open`

	curl -i -H 'Accept: application/json' -d 'row=0&column=0&board_id=2' http://fast-scrubland-04933.herokuapp.com/square/open

### Response

Get status about all boxes from board

    HTTP/1.1 200 OK
    Server: Cowboy
    Date: Thu, 08 Jul 2021 04:26:17 GMT
    Connection: keep-alive
    Content-Type: application/json; charset=utf-8
    Vary: Accept

    {"status":"continue","message":"nice continue playing","data":[{"id":10,"row":0,"column":0,"value":1,"mine":false,"open":true,"board_id":2,"created_at":"2021-07-08T04:16:41.479Z","updated_at":"2021-07-08T04:26:18.055Z"},{"id":11,"row":0,"column":1,"value":0,"mine":true,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.487Z","updated_at":"2021-07-08T04:16:41.559Z"},{"id":12,"row":0,"column":2,"value":0,"mine":true,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.494Z","updated_at":"2021-07-08T04:16:41.551Z"},{"id":13,"row":1,"column":0,"value":2,"mine":false,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.502Z","updated_at":"2021-07-08T04:16:41.595Z"},{"id":14,"row":1,"column":1,"value":3,"mine":false,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.511Z","updated_at":"2021-07-08T04:16:41.607Z"},{"id":15,"row":1,"column":2,"value":3,"mine":false,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.518Z","updated_at":"2021-07-08T04:16:41.615Z"},{"id":16,"row":2,"column":0,"value":1,"mine":false,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.526Z","updated_at":"2021-07-08T04:16:41.623Z"},{"id":17,"row":2,"column":1,"value":0,"mine":true,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.533Z","updated_at":"2021-07-08T04:16:41.566Z"},{"id":18,"row":2,"column":2,"value":1,"mine":false,"open":false,"board_id":2,"created_at":"2021-07-08T04:16:41.539Z","updated_at":"2021-07-08T04:16:41.633Z"}]}

