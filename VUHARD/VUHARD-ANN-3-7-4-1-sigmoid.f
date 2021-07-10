C **********************************************************************
C Function to compute the ANN : 3-7-4-1-sigmoid yield stress
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
      do k = 1, nblock
C xepsp = (eqps(k) - minEntries[0]) / rangeEntries[0]
      xepsp = (eqps(k) - 0.0)/1.0
C xdepsp = (log(depsp/logBase) - minEntries[1]) / rangeEntries[1]
      xdepsp = (log(eqpsRate(k)/1.0) - 0.0)/10.819778284410
C xtemp = (temp - minEntries[2]) / rangeEntries[2]
      xtemp = (tempNew(k) - 20.0)/480.0
C za = np.exp(-w1.dot(x)  -  b1)
      za0 = exp(-0.119231261313*xepsp - 0.173828095198*xdepsp +
     +  1.827572464943*xtemp - 1.533527970314)
      za1 = exp(-0.428523629904*xepsp - 0.572129368782*xdepsp +
     +  1.296182870865*xtemp + 1.823030114174)
      za2 = exp(132.502944946289*xepsp - 0.074804469943*xdepsp +
     +  0.372308045626*xtemp + 1.611178278923)
      za3 = exp(-0.238687828183*xepsp - 0.654297590256*xdepsp -
     +  1.221466302872*xtemp - 0.612167119980)
      za4 = exp(-0.216847836971*xepsp - 0.142032980919*xdepsp +
     +  3.807989597321*xtemp - 0.042427442968)
      za5 = exp(16.061351776123*xepsp - 0.115588687360*xdepsp +
     +  0.412052661180*xtemp + 1.614393234253)
      za6 = exp(3.105705261230*xepsp - 0.138235300779*xdepsp +
     +  0.773996531963*xtemp + 1.072145581245)
C zb = 1 + za
      zb0 = 1.0 + za0
      zb1 = 1.0 + za1
      zb2 = 1.0 + za2
      zb3 = 1.0 + za3
      zb4 = 1.0 + za4
      zb5 = 1.0 + za5
      zb6 = 1.0 + za6
C zc = w2.dot(zb) + b2
      zc0 = exp(1.296875834465/zb0 +
     +  1.162090778351/zb1 +
     +  10.487031936646/zb2 +
     +  0.098825834692/zb3 +
     +  0.730871379375/zb4 -
     +  4.092911243439/zb5 +
     +  1.342621445656/zb6 +
     +  0.492944657803)
      zc1 = exp(-0.416251301765/zb0 +
     +  1.612317681313/zb1 -
     +  1.245551109314/zb2 +
     +  0.976023316383/zb3 +
     +  0.005203731358/zb4 -
     +  1.697751402855/zb5 -
     +  0.834678351879/zb6 -
     +  0.692925989628)
      zc2 = exp(-1.942471027374/zb0 -
     +  0.364910364151/zb1 +
     +  10.365681648254/zb2 -
     +  0.165790036321/zb3 -
     +  0.691674530506/zb4 -
     +  5.159326076508/zb5 +
     +  2.959228277206/zb6 -
     +  0.345911204815)
      zc3 = exp(-1.463814258575/zb0 -
     +  0.175867184997/zb1 +
     +  0.670381665230/zb2 -
     +  0.306437820196/zb3 -
     +  0.191420003772/zb4 +
     +  2.523961305618/zb5 +
     +  0.034361626953/zb6 +
     +  0.274670749903)
C y = w3.dot(xd) + b3
      y =-1.342184662819/(1.0 + zc0) -
     +  1.402877211571/(1.0 + zc1) +
     +  1.547661781311/(1.0 + zc2) +
     +  0.745113432407/(1.0 + zc3) -
     +  0.319332510233
C zd = w3v*(xd / (1 + zc)**2)
      zd0 =-1.342184662819*(zc0/(1.0 + zc0)**2)
      zd1 =-1.402877211571*(zc1/(1.0 + zc1)**2)
      zd2 = 1.547661781311*(zc2/(1.0 + zc2)**2)
      zd3 = 0.745113432407*(zc3/(1.0 + zc3)**2)
C ze = za / (1 + za)**2
      ze0 = za0 / zb0**2
      ze1 = za1 / zb1**2
      ze2 = za2 / zb2**2
      ze3 = za3 / zb3**2
      ze4 = za4 / zb4**2
      ze5 = za5 / zb5**2
      ze6 = za6 / zb6**2
C zf = (w2.T).dot(zd) * xd
      zf0 = (-1.296875834465*zd0 +
     +  0.416251301765*zd1 +
     +  1.942471027374*zd2 +
     +  1.463814258575*zd3)*ze0
      zf1 = (-1.162090778351*zd0 -
     +  1.612317681313*zd1 +
     +  0.364910364151*zd2 +
     +  0.175867184997*zd3)*ze1
      zf2 = (-10.487031936646*zd0 +
     +  1.245551109314*zd1 -
     +  10.365681648254*zd2 -
     +  0.670381665230*zd3)*ze2
      zf3 = (-0.098825834692*zd0 -
     +  0.976023316383*zd1 +
     +  0.165790036321*zd2 +
     +  0.306437820196*zd3)*ze3
      zf4 = (-0.730871379375*zd0 -
     +  0.005203731358*zd1 +
     +  0.691674530506*zd2 +
     +  0.191420003772*zd3)*ze4
      zf5 = (4.092911243439*zd0 +
     +  1.697751402855*zd1 +
     +  5.159326076508*zd2 -
     +  2.523961305618*zd3)*ze5
      zf6 = (-1.342621445656*zd0 +
     +  0.834678351879*zd1 -
     +  2.959228277206*zd2 -
     +  0.034361626953*zd3)*ze6
C yd = (w1.T).dot(zf)
      yd0 = 0.119231261313*zf0 +
     +  0.428523629904*zf1 -
     +  132.502944946289*zf2 +
     +  0.238687828183*zf3 +
     +  0.216847836971*zf4 -
     +  16.061351776123*zf5 -
     +  3.105705261230*zf6
      yd1 = 0.173828095198*zf0 +
     +  0.572129368782*zf1 +
     +  0.074804469943*zf2 +
     +  0.654297590256*zf3 +
     +  0.142032980919*zf4 +
     +  0.115588687360*zf5 +
     +  0.138235300779*zf6
      yd2 =-1.827572464943*zf0 -
     +  1.296182870865*zf1 -
     +  0.372308045626*zf2 +
     +  1.221466302872*zf3 -
     +  3.807989597321*zf4 -
     +  0.412052661180*zf5 -
     +  0.773996531963*zf6
      Yield(k) = 977.555715042962*y + 579.184642915415
      dyieldDeqps(k,1) = 977.555715042962*yd0
      dyieldDeqps(k,2) = 90.348959964501*yd1 / eqpsRate(k)
      dyieldDtemp(k) = 2.036574406340*yd2
      end do
C
      return
      end
