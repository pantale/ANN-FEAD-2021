C **********************************************************************
C Function to compute the Johnson-Cook yield stress
C **********************************************************************
      function yieldStress (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm )
      include 'vaba_param.inc'
C Hardening part of the Johnson-Cook law
      hardPart = parA + parB * epsp**parn
C Dependence to the deformation rate
      if (depsp .gt. pardepsp0) then
        viscPart = 1.0 + parC * log (depsp/pardepsp0)
      else
        viscPart = 1.0
      end if
C Dependence to the temperature if parT0 < temp < parTm
      tempPart = 1.0
      if (temp > parT0) then
        if (temp < parTm) then
          tempPart = 1.0 - ((temp - parT0) / (parTm - parT0))**parm
        else
          tempPart = 0.0
       end if
      end if
C Compute and return the yield stress
      yieldStress = hardPart * viscPart * tempPart
      return
      end
C
C **********************************************************************
C Function to compute the Johnson-Cook hardening / epsp
C **********************************************************************
      function yieldHardEpsp (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm )
      include 'vaba_param.inc'
C Hardening part of the Johnson-Cook law
      hardPart = parn * parB * (epsp**(parn - 1.0))
C Dependence to the deformation rate
      if (depsp .gt. pardepsp0) then
        hardPart = hardPart * (1.0 + parC * log (depsp/pardepsp0))
      end if
C Dependence to the temperature if parT0 < temp < parTm
      tempPart = 1.0
      if (temp > parT0) then
        if (temp < parTm) then
          tempPart = 1.0 - ((temp - parT0) / (parTm - parT0))**parm
        else
          tempPart = 0.0
       end if
      end if
C Compute and return the yield stress
      yieldHardEpsp = hardPart * tempPart
      return
      end
C
C **********************************************************************
C Function to compute the Johnson-Cook hardening / depsp
C **********************************************************************
      function yieldHardDepsp (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm )
      include 'vaba_param.inc'
C Hardening part of the Johnson-Cook law
      hardPart = 0.0
C Dependence to the deformation rate
      if (depsp .gt. pardepsp0) then
        hardPart = (parA + parB * epsp**parn) * parC / depsp
      end if
C Dependence to the temperature if parT0 < temp < parTm
      tempPart = 1.0
      if (temp > parT0) then
        if (temp < parTm) then
          tempPart = 1.0 - ((temp - parT0) / (parTm - parT0))**parm
        else
          tempPart = 0.0
       end if
      end if
C Compute and return the yield stress
      yieldHardDepsp = hardPart * tempPart
      return
      end
C
C **********************************************************************
C Function to compute the Johnson-Cook hardening / T
C **********************************************************************
      function yieldHardTemp (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm )
      include 'vaba_param.inc'
C Hardening part of the Johnson-Cook law
      hardPart = parA + parB * epsp**parn
C Dependence to the deformation rate
      if (depsp .gt. pardepsp0) then
        viscPart = 1.0 + parC * log (depsp/pardepsp0)
      else
        viscPart = 1.0
      end if
C Dependence to the temperature if parT0 < temp < parTm
      tempPart = 0.0
      if (temp > parT0 .and. temp < parTm) then
        tempPart = -parm*(((temp - parT0)/(parTm - parT0))**(parm))
     1    / (temp - parT0)
      end if
C Compute and return the yield stress
      yieldHardTemp = hardPart * viscPart * tempPart
      return
      end
C
C **********************************************************************
C J2 Mises Plasticity with isotropic Johnson-Cook hardening
C **********************************************************************
      subroutine vuhard (
C Read only -
     1     nblock,
     2     nElement, nIntPt, nLayer, nSecPt,
     3     lAnneal, stepTime, totalTime, dt, cmname,
     4     nstatev, nfieldv, nprops,
     5     props, tempOld, tempNew, fieldOld, fieldNew,
     6     stateOld,
     7     eqps, eqpsRate,
C Write only -
     8     yield, dyieldDtemp, dyieldDeqps,
     9     stateNew )
C
      include 'vaba_param.inc'
C
      dimension nElement(nblock),
     1     props(nprops),
     2     tempOld(nblock),
     3     fieldOld(nblock,nfieldv),
     4     stateOld(nblock,nstatev),
     5     tempNew(nblock),
     6     fieldNew(nblock,nfieldv),
     7     eqps(nblock),
     8     eqpsRate(nblock),
     9     yield(nblock),
     1     dyieldDtemp(nblock),
     2     dyieldDeqps(nblock,2),
     3     stateNew(nblock,nstatev)
C
      character*80 cmname
C
C **********************************************************************
C Start of the subroutine grab the parameters of the constitutive law
C **********************************************************************
      parA      = props(1)
      parB      = props(2)
      parn      = props(3)
      parC      = props(4)
      parm      = props(5)
      pardepsp0 = props(6)
      parT0     = props(7)
      parTm     = props(8)
C
C **********************************************************************
C Main computation block
C **********************************************************************
      do k = 1, nblock
        epsp = eqps(k)
        depsp = eqpsRate(k)
        temp = tempNew(k)
C Compute the yield stress
        Yield(k) = yieldStress(epsp, depsp, temp,
     1    parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
C Compute derivative of yield / epsp
        dyieldDeqps(k,1) = yieldHardEpsp(epsp, depsp, temp,
     1    parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
C Compute derivative of yield / depsp
        dyieldDeqps(k,2) = yieldHardDepsp(epsp, depsp, temp,
     1    parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
C Compute derivative of yield / temp
        dyieldDtemp(k) = yieldHardTemp(epsp, depsp, temp,
     1    parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      end do
C
      return
      end
