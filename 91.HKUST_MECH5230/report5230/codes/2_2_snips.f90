
    program main
    implicit none
    integer, parameter :: Lx=15
    real(8) :: dx, dt
    integer :: i
    integer, parameter :: nx=20
    real(8) :: X(0:nx)
    real(8) :: T(0:nx), Tn(0:nx)
    real(8), parameter :: alpha=1.0d0
    integer :: itc
    integer, parameter :: itc_max=10000000
    real(8), parameter :: eps=1e-7
    real(8) :: error1, error2, errorT
    real(8) :: time1, time2
    integer :: itc1, itc2

    dx = dble(Lx)/dble(nx)
    dt = 0.9d0*dx**2
    time1 = 2.0d0
    time2 = 10.0d0
    itc1 = int(time1/dt)
    itc2 = int(time2/dt)
    do i=0,nx
        X(i) = dble(i)*dx
    enddo

    itc = 0
    errorT = 100

    T = 0.0d0
    Tn = 0.0d0
    T(0) = 0.0d0
    T(nx) = X(nx)**2*dexp(-X(nx))

    do while( (itc.LT.itc_max).AND.(errorT.GT.eps) )

        itc = itc+1

        do i=1,nx-1
            T(i) = T(i)+dt*( alpha*(T(i+1)-2.0d0*T(i)+T(i-1))/dx/dx-(X(i)**2-4.0d0*X(i)+2.0d0)*dexp(-X(i)) )
        enddo

        if(itc.Eq.itc1) then
            open(unit=01,file="t2-FTCS.dat",status="unknown")
            do i=0,nx
                write(01,*) X(i), T(i)
            enddo
            close(01)
        endif


        if(itc.Eq.itc2) then
            open(unit=01,file="t10-FTCS.dat",status="unknown")
            do i=0,nx
                write(01,*) X(i), T(i)
            enddo
            close(01)
        endif

        if(MOD(itc,100).EQ.0) then
            error1 = 0.0d0
            error2 = 0.0d0
            do i=1,nx-1
                error1 = error1+dabs(T(i)-Tn(i))
                error2 = error2+dabs(T(i))
            enddo
            errorT = error1/error2

            Tn = T
            write(*,*) itc, errorT
        endif

    enddo


    open(unit=01,file="numerical.dat",status="unknown")
    do i=0,nx
        write(01,*) X(i), T(i)
    enddo
    close(01)

    stop
    end program main
