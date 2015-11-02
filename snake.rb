require 'rubygems'
require 'gosu'

class Snake
	attr_accessor :x, :y, :vel_x, :vel_y, :moving, :direction
	def initialize(window, x, y, vel_x, vel_y)
		@x = x
		@y = y
		@vel_x = vel_x
		@vel_y = vel_y
		@w = 30
		@h = 30
		@moving = false
		@direction = "none"
		@image = Gosu::Image.new(window, "./resources/block.png", true)
	end
	
	def move
		if @moving == true
		if @direction == "LEFT"
			@x -= 30
			sleep 0.13
		elsif @direction == "RIGHT"
			@x += 30
			sleep 0.13
		elsif @direction == "UP"
			@y -= 30
			sleep 0.13
		elsif @direction == "DOWN"
			@y += 30
			sleep 0.13
		end
		end
	end	
	
	def draw
		@image.draw(@x, @y, 2)
	end
	
	def update
		move
	end
end

class Food
	attr_accessor :x, :y
	def initialize(window)
		@x = 5 + (30 * (((rand(970)) + 10) / 30))
		@y = 5 + (30 * (((rand(970)) + 10) / 30))
		@image = Gosu::Image.new(window, "./resources/food.png")
	end

	def draw
		@image.draw(@x, @y, 1)
	end
end	

class Background
	def initialize(window, x, y, path)
		@x = x
		@y = y
		@path = path
		@image = Gosu::Image.new(window, @path, false)
	end

	def draw
		@image.draw(@x, @y, 0)
	end
end

class Menu
	def initialize(window, x, y, path)
		@x = x
		@y = y
		@path = path
		@image = Gosu::Image.new(window, @path, false)
	end
	
	def draw
		@image.draw(@x, @y, 2)
	end
end

class Score
	attr_accessor :value
	def initialize(window)
		@x = 460
		@y = 10
		@value = 0
		@font = Gosu::Font.new(window, "Times New Roman", 100)
	end
	
	def draw
		@font.draw("#{@value}", @x, @y, 1, factor_x = 1, factor_y = 1, color = 0xff0000ff, mode = :default)	
	end
end

class Window < Gosu::Window
	def initialize
		super 1000, 1000, false, 0.1
		self.caption = 'Snake'
		@@game_state = "ACTION"
		@snake = Snake.new(self, 5, 5, 30, 30)
		@food = Food.new(self)
		@background = Background.new(self, 0, 0, "./resources/background.png")
		@score = Score.new(self)
	end
	
	def change_game_state
		if @@game_state == "ACTION"
			@@game_state = "PLAYING"
		else
			@@game_state = "ACTION"
		end
	end
	
	def grow
		if @snake.direction == "LEFT"
			@snake = Gosu::Image.load_tiles(self, "./resources/block.png", -30, 0, true)
		end	
	end
	
	def button_down(id)
		case id
			when Gosu::KbLeft
				if @snake.moving == false
					@snake.moving = true
					@snake.direction = "LEFT"
				else
					@snake.direction = "LEFT"
				end
			when Gosu::KbRight
				if @snake.moving == false
					@snake.moving = true
					@snake.direction = "RIGHT"
				else
					@snake.direction = "RIGHT"
				end
			when Gosu::KbUp
				if @snake.moving == false
					@snake.moving = true
					@snake.direcetion = "UP"
				else
					@snake.direction = "UP"
				end
			when Gosu::KbDown
				if @snake.moving == false
					@snake.moving = true
					@snake.direction = "DOWN"
				else
					@snake.direction = "DOWN"
				end
			when Gosu::KbP
				change_game_state
			when Gosu::KbEscape
				self.close
		end
	end
				
	def needs_cursor?
		true
	end
  
	def eat_food
		@food.x = 5 + (30 * (((rand(970)) + 10) / 30))
		@food.y = 5 + (30 * (((rand(970)) + 10) / 30))
	end

	def draw
		if @@game_state == "ACTION"
			@background.draw
			@snake.draw
			@food.draw
			@score.draw
		elsif @@game_state == "PAUSE"
		end
	end
	
	def update
		@snake.update
		if @snake.x == @food.x and @snake.y == @food.y
			@score.value += 1
			eat_food
		end	
		if @snake.x > 960
			@snake.vel_x *= -1
		end
	end
end

Window.new.show

