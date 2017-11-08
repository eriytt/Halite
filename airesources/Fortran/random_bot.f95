! Example for test
! 1 3 3 2 3 4 1 2 3 0 1 2   1 0 2 1 2 0 1 1 2 2 1 0 122 25 18 13 45 22 255 85 0
!		
program random_bot
	use hlt
	type(game_t):: game
	type(site_t):: site	
	real:: time
	integer, dimension(3) :: tarray
  integer:: x, y, direction, seed;
	  
	call itime(tarray)
	seed = tarray(1) + tarray(2) + tarray(3)
	call srand(seed)	
	game = GetInit()

	! Example of logging to file randomBot.log
	call LoggerInit("randomBot.log", 20)
	call Log("Example log message with an extra new line"//NEW_LINE('A'))
	! call LogGame(game)
	! site = GetSiteFromXY(game, 5, 5)
	! call LogSite(site)
	
  call SendInit("Fortran Random Bot");

	do 
		call GetFrame(game)			
		do x = 1, game%width
			do y = 1, game%height
				site = GetSiteFromXY(game, x, y)
				if (site%owner == game%playertag) then
					direction = mod(irand(), 5)
					call SetMove(game, x, y, direction);
				end if
			end do
		end do
		call SendFrame(game);
	end do
	
	call LoggerClose()
end  program 