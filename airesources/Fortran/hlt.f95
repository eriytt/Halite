!
!    Useful functions/subroutines:
!
!        function game_t GetInit()
!        subroutine SendInit(character(len=*) botname)
!        subroutine GetFrame(game_t game)
!        subroutine SetMove(game_t game, integer x, integer y, integer direction)
!        subroutine SendFrame(game_t game)
!
!    Convenience functions:
!
!        function site_t GetSiteFromXY(game_t game, integer x, integer y)
!        function site_t GetSiteFromMovement(game_t game, integer src_x, integer src_y, integer direction)
!   
!    Logging to file for degugging purposes:
!
!        subroutine LogInit(character(len=*) filename, integer fileunit)
!        subroutine Log(character(len=*) message)
!        subroutine LogGame(game_t game) 
!        subroutine LogSite(site_t game) 
!
!    Types:
!
!        direction:  see constants code below
!        site_t: see Derived Type in code below
!        game_t: see Derived Type in code below
!
!
!    More documentation and some better bots are at (C language):
!    https://github.com/fohristiwhirl/chalite
!

module hlt
  implicit none
  private
  public LogGame, LogSite, GetInit, SendInit, GetFrame, GetSiteFromXY, GetSiteFromMovement, SetMove, SendFrame
  public LoggerInit, Log, LoggerClose
  public site_t, game_t, STILL, NORTH, EAST, SOUTH, WEST

  type site_t
    integer:: x, y, owner, strength, production
  end type
    
  type game_t
    integer::  width, height, playertag
    integer, allocatable:: moves(:, :), owner(:,:), production(:,:), strength(:,:)
  end type

  integer, parameter:: STILL = 0
  integer, parameter:: NORTH = 1
  integer, parameter:: EAST = 2
  integer, parameter:: SOUTH = 3
  integer, parameter:: WEST = 4

  integer, parameter :: CLOSED_UNIT = -9999

  integer:: log_fileunit = CLOSED_UNIT

  contains

  subroutine print_array(array, name)     
    integer, allocatable, intent(in):: array(:,:)
    character(len=*), intent(in):: name
    integer:: x, y
    write (log_fileunit, "(A)") name
    do y = 1, size(array, 1)
        do x = 1, size(array, 2)
          write (log_fileunit, "(I3,A,I3,I5)") x, ':', y, array(x, y)
        end do
    end do
  end subroutine

  function new_2d_int_array(width, height) result(allocated_array)
    integer, allocatable:: allocated_array(:,:)
    integer:: width, height, allocate_status
    allocate (allocated_array(width, height), STAT = allocate_status)
    if (allocate_status /= 0) then
      print *, "Alloc failed in new_2d_int_array()"
      call exit(1)
    endif
  end function

  function getnextint() result(next_int)

    character:: ch
    integer:: status, result, next_int
    logical:: seen_any_digits

    result = 0
    seen_any_digits = .false.

    do 
      status = fget(ch)      
      if (status /= 0) then
        print *, "EOF received. Halite engine quit?"
        call exit(1)
      end if
      if (ch >= '0' .and. ch <= '9') then
        seen_any_digits = .true.
        result = result * 10
        result = result + ichar(ch) - 48
      else if (seen_any_digits) then
        exit            
      end if
    end do
    next_int = result
  end function

  subroutine parseproduction(game) 
    type(game_t):: game
    integer:: x, y, production

    do y = 1, game%height
        do x = 1, game%width
          production = getnextint()
          game%production(x, y) = production
        end do
    end do
  end subroutine

  subroutine parsemap(game)
    type(game_t):: game

    integer:: x, y
    integer:: run
    integer:: owner
    integer:: total_set
    integer:: set_this_run

    x = 1
    y = 1
    total_set = 1
     
    do while (total_set <= game%width * game%height) 
      run = getnextint()
      owner = getnextint()

      do set_this_run = 1, run
        game%owner(x, y) = owner
        total_set = total_set + 1
        x = x + 1
        if (x > game%width) then 
          x = 1
          y = y + 1
        end if
      end do
    end do

    do y = 1, game%height
        do x = 1, game%width
            game%strength(x, y) = getnextint()
        end do
    end do
  end subroutine

  function sanitise_x(game, x) result(x_san) 
    type(game_t):: game
    integer, intent(in):: x
    integer:: x_san

    x_san = x
    x_san = mod(x_san - 1, game%width) + 1
    if (x_san < 1) x_san = game%width + x_san
  end function

  function sanitise_y(game, y) result(y_san)     
    type(game_t):: game
    integer, intent(in):: y
    integer:: y_san
    
    y_san = y
    y_san = mod(y_san - 1, game%height) + 1
    if (y_san < 1) y_san = game%height + y_san  
  end function

  subroutine LoggerInit(filename, fileunit)
    character(len=*), intent(in)  :: filename
    integer:: flag
    integer, intent(in):: fileunit

    open(fileunit,file=filename,action='write', &
         asynchronous='yes',iostat=flag,status='replace')
    if (flag /= 0) error stop 'Error opening log file.'
    log_fileunit = fileunit
  end subroutine LoggerInit

  subroutine Log(message)
    character(len=*), intent(in) :: message
    write(log_fileunit, ("(A)")) message
    call flush()
  end subroutine Log

  subroutine LoggerClose()
    if (log_fileunit == CLOSED_UNIT) return
    close(log_fileunit)
    log_fileunit = CLOSED_UNIT
  end subroutine LoggerClose

  function GetInit() result(game)
    type(game_t):: game
    
    game%playertag = getnextint()
    game%width = getnextint()
    game%height = getnextint()

    game%moves = new_2d_int_array(game%width, game%height)
    game%owner = new_2d_int_array(game%width, game%height)
    game%production = new_2d_int_array(game%width, game%height)
    game%strength = new_2d_int_array(game%width, game%height)

    call parseproduction(game)
    call parsemap(game)
    game%moves = 0.
  end function

  subroutine SendInit(botname)    
    character(len=*),intent(in)   :: botname
    print *, botname
    call flush()
  end subroutine

  subroutine GetFrame(game) 
    type(game_t):: game

    call parsemap(game)
    ! Reset the moves array while we're at it.    
    game%moves = 0.
  end subroutine

  function GetSiteFromXY(game, x, y) result(site)
    type(game_t):: game
    type(site_t):: site
    integer, intent(in):: x, y

    site%x = sanitise_x(game, x)
    site%y = sanitise_y(game, y)    

    site%owner = game%owner(site%x, site%y)
    site%production = game%production(site%x, site%y)
    site%strength = game%strength(site%x, site%y)
  end function


  function GetSiteFromMovement(game, src_x, src_y, direction) result(nextSite) 
    type(game_t):: game
    type(site_t):: nextSite
    integer, intent(in):: src_x, src_y, direction
    integer:: x, y

    x = src_x
    y = src_y

    select case (direction)
      case(NORTH)
          y = y - 1
      case(EAST)
          x = x + 1
      case(SOUTH)
          y = y + 1
      case(WEST)
          x = x - 1
    end select

      x = sanitise_x(game, x)
      y = sanitise_y(game, y)

      nextSite = GetSiteFromXY(game, x, y) 
  end function

  subroutine SetMove(game, x, y, direction)
    type(game_t):: game
    integer, intent(in):: x, y, direction
    game%moves(sanitise_x(game, x), sanitise_y(game, y)) = direction
  end subroutine

  subroutine SendFrame(game) 
    type(game_t):: game    
    integer:: x, y
    do x = 1, game%width
      do y = 1, game%height
        if ((game%moves(x, y) /= STILL) .and. (game%owner(x, y) == game%playertag)) then
          write (*, "(I0,A,I0,A,I0,A)", advance='no') x - 1, " ", y - 1, " ", game%moves(x, y), " "
        end if
      end do
    end do
    print *, ""
    call flush()
  end subroutine

  subroutine LogGame(game) 
    type(game_t), intent(in):: game
    write (log_fileunit,"(A,I3)") "Player tag: ", game%playertag
    write (log_fileunit,"(A,I3,A,I3)") "Size (W,H): ", game%width, ",", game%height
    call print_array(game%production, "*** Production ***")
    call print_array(game%owner, "*** Owner ***")
    call print_array(game%strength, "*** Strength ***")
    call print_array(game%moves, "*** Move ***")
  end subroutine

  subroutine LogSite(site) 
    type(site_t), intent(in):: site
    write (log_fileunit,"(A,I3,A,I3)") "(x,y): ", site%x, ",", site%y
    write (log_fileunit,"(A,I3)") "owner: ", site%owner
    write (log_fileunit,"(A,I3)") "strength: ", site%strength
    write (log_fileunit,"(A,I3)") "production: ", site%production
  end subroutine

end module hlt
