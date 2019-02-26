<CsoundSynthesizer>

<CsInstruments>
; ================================================================
; ORQUESTA
; ================================================================

sr  =   44100
ksmps   =   10
nchnls = 2
0dbfs = 1

opcode pSelector_k, k, iiii
   iComp, iMin, iMax, iDev xin
  
  if iComp > 0 then
    kOut = iComp
  elseif iComp < 0 then
    kOut oscil1i 0, 1, p3, iComp * -1
  else
    iOut random iMin, iMax
    kOut = iOut
  endif

  if iDev > 0 then
    kOut *= 2 ^ (random(-iDev, iDev) / 100)
  endif
  
  if kOut < iMin then
    kOut = iMin
  elseif kOut > iMax then
    kOut = iMax
  endif
  ;printk2 kOut  
  xout kOut
endop

opcode pSelector_default_k, k, iiii
   iComp, iMin, iMax, iDef xin
  
  if iComp > 0 then
    kOut = iComp
  elseif iComp < 0 then
    kOut oscil1i 0, 1, p3, iComp * -1
  else
    kOut = iDef
  endif

  if kOut < iMin then
    kOut = iMin
  elseif kOut > iMax then
    kOut = iMax
  endif

  xout kOut
endop


opcode pSelector_mult_k, k, iiii
   iComp, iMin, iMax, iMult xin
  
  if iComp > 0 then
    kOut = iComp
  elseif iComp < 0 then
    kOut oscil1i 0, 1, p3, iComp * -1
  else
    iOut random iMin, iMax
    kOut = iOut
  endif

  if iMult <= 0 then
    iMult = 1
  endif
 
  kOut *= iMult
  
  if kOut < iMin then
    kOut = iMin
  elseif kOut > iMax then
    kOut = iMax
  endif
  ;printk2 kOut  
  xout kOut
endop


garevL   init    0
garevR   init    0

seed 0
chnset 0, "p3_max_dur"

; ================================================
; modulación de frecuencia con dos osciladores
; ================================================
instr FM_Turenas     

  idur    =   p3          ; duración total 
  iamp    =   ampdbfs(p4) ; amplitud
  ifc     =   p5          ; frecuencia portante
  ifm     =   ifc / p6    ; frecuencia modulante
  indx1   =   p7          ; índice de modulación máximo
  indx0   =   p8          ; índice de modulación mínimo
  iafn    =   p9          ; función de envolvente de intensidad
  imfn    =   p10         ; función de envolvente de índice de modulación
  ipan    =   p11         ; paneo
  irev    =   p12         ; envío a la reverberación

  indx    =   indx1 - indx0 

  kamp   oscil1   0,   iamp,   idur,   iafn   ; envolvente de amplitud
  kndx   oscil1   0,   indx,   idur,   imfn   ; envolvente de índice de modulación
  
  kndx    =   kndx + indx0
  kdev    =   kndx *  ifm      ; desviación de frecuencia

  amod   oscili   kdev,         ifm,   -1       ; oscilador modulante
  acar   oscili   kamp,  ifc + amod,   -1       ; oscilador portante
  
  aOutL, aOutR pan2 acar, ipan

           out    aOutL, aOutR

  garevL += aOutL * irev
  garevR += aOutR * irev

endin

instr FM_Basico

  aMod poscil p6, p7, -1
  aCar poscil p4, p5 + aMod, -1

  aOutL, aOutR pan2 aCar, p8
 
             out    aOutL, aOutR
             
  garevL += aOutL * p9
  garevR += aOutR * p9

endin

; p4 amp
; p5 freq
; p6 fn
; p7 phase
; p8 pan
; p9 reverb
; p10 durdev
; p11 ampdev
; p12 freqdev
; p13 pandev
; p14 revdev

instr Aditiva_dev
 
  p3      =       p3 * 2 ^ (random(-p10, p10) / 100)
  print p3
  ip3_max_dur chnget "p3_max_dur"
  if  ip3_max_dur < p3 then
     chnset p3, "p3_max_dur"
  endif
  aSig      poscil        pSelector_k(p4,  0,     1, p11), 
                           pSelector_k(p5, 20, 6000, p12), 
                                     (p6  <  1 ? -1 : p6), 
              (p7  >= 0 && p7 <= 1 ? p7 : random:i(0, 1))


  aOutL, aOutR pan2 aSig, pSelector_k(p8,  0,  1, p14)

                out aOutL, aOutR
  krev = pSelector_k(p9,  0, 1,  p14)
  garevL += aOutL * krev
  garevR += aOutR * krev
  
endin

; p4  amp
; p5  freq
; p6  amp
; p7  freq
; p8  pan
; p9  reverb
; p10 fn
; p11 phase

instr Aditiva
 
  
  aSig         poscil    pSelector_mult_k(p4,  0,     1, p6), 
                          pSelector_mult_k(p5, 20, sr/2, p7), 
                                      (p10  <  1 ? -1 : p10), 
              (p11  >= 0 && p11 <= 1 ? p11 : random:i(0, 1))

  aOutL, aOutR pan2 aSig, pSelector_default_k(p8,  0,  1, 0.5)

                out aOutL, aOutR
  krev = pSelector_default_k(p9,  0, 1,  0)
  garevL += aOutL * krev
  garevR += aOutR * krev
  
endin




instr Sus_LP

  ; asign p-fields to variables
  iCPS   =            cpsmidinn(p4) ;convert from note number to cps
  kAmp1  =            p5
  iType1 =            p6
  kPW1   =            p7
  kOct1  =            octave(p8) ;convert from octave displacement to multiplier
  kTune1 =            cent(p9)   ;convert from cents displacement to multiplier
  kAmp2  =            p10
  iType2 =            p11
  kPW2   =            p12
  kOct2  =            octave(p13)
  kTune2 =            cent(p14)
  iCF    =            p15
  iFAtt  =            p16
  iFDec  =            p17
  iFSus  =            p18
  iFRel  =            p19
  kRes   =            p20
  iAAtt  =            p21
  iADec  =            p22
  iASus  =            p23
  iARel  =            p24

  ;oscillator 1
  ;if type is sawtooth or square...
  if iType1==1||iType1==2 then
   ;...derive vco2 'mode' from waveform type
   iMode1 = (iType1=1?0:2)
   aSig1  vco2   kAmp1,iCPS*kOct1*kTune1,iMode1,kPW1;VCO audio oscillator
  else                                   ;otherwise...
   aSig1  noise  kAmp1, 0.5              ;...generate white noise
  endif

  ;oscillator 2 (identical in design to oscillator 1)
  if iType2==1||iType2==2 then
   iMode2  =  (iType2=1?0:2)
   aSig2  vco2   kAmp2,iCPS*kOct2*kTune2,iMode2,kPW2
  else
    aSig2 noise  kAmp2,0.5
  endif

  ;mix oscillators
  aMix       sum          aSig1,aSig2
  ;lowpass filter
  kFiltEnv   expsegr      0.0001,iFAtt,iCPS*iCF,iFDec,iCPS*iCF*iFSus,iFRel,0.0001
  aOut       moogladder   aMix, kFiltEnv, kRes
  
  ;amplitude envelope
  aAmpEnv    expsegr      0.0001,iAAtt,1,iADec,iASus,iARel,0.0001
  aOut       =            aOut*aAmpEnv
               out          aOut,aOut

endin



  instr Sus_LHBP_trig ; triggers notes in instrument 2 with randomised p-fields
krate  randomi 0.2,0.4,0.1   ;rate of note generation
ktrig  metro  krate          ;triggers used by schedkwhen
koct   random 5,12           ;fundemental pitch of synth note
kdur   random 15,30          ;duration of note
schedkwhen ktrig,0,0,"Sus_LHBP",0,kdur,cpsoct(koct) ;trigger a note in instrument 2
  endin

  instr Sus_LHBP ; subtractive synthesis instrument
  print p2, p3, p4
aNoise  pinkish  1                  ;a noise source sound: pink noise
kGap    rspline  0.3,0.05,0.2,2     ;time gap between impulses
aPulse  mpulse   15, kGap           ;a train of impulses
kCFade  rspline  0,1,0.1,1          ;crossfade point between noise and impulses
aInput  ntrpol   aPulse,aNoise,p6;implement crossfade

; cutoff frequencies for low and highpass filters
kLPF_CF  rspline  13,8,0.1,0.4
kHPF_CF  rspline  5,10,0.1,0.4
; filter input sound with low and highpass filters in series -
; - done twice per filter in order to sharpen cutoff slopes
aInput    butlp    aInput, cpsoct(kLPF_CF)
aInput    butlp    aInput, cpsoct(kLPF_CF)
aInput    buthp    aInput, cpsoct(kHPF_CF)
aInput    buthp    aInput, cpsoct(kHPF_CF)

kcf     rspline  p4*1.05,p4*0.95,0.01,0.1 ; fundemental
; bandwidth for each filter is created individually as a random spline function
kbw1    rspline  0.00001,10,0.2,1
kbw2    rspline  0.00001,10,0.2,1
kbw3    rspline  0.00001,10,0.2,1
kbw4    rspline  0.00001,10,0.2,1
kbw5    rspline  0.00001,10,0.2,1
kbw6    rspline  0.00001,10,0.2,1
kbw7    rspline  0.00001,10,0.2,1
kbw8    rspline  0.00001,10,0.2,1
kbw9    rspline  0.00001,10,0.2,1
kbw10   rspline  0.00001,10,0.2,1
kbw11   rspline  0.00001,10,0.2,1
kbw12   rspline  0.00001,10,0.2,1
kbw13   rspline  0.00001,10,0.2,1
kbw14   rspline  0.00001,10,0.2,1
kbw15   rspline  0.00001,10,0.2,1
kbw16   rspline  0.00001,10,0.2,1
kbw17   rspline  0.00001,10,0.2,1
kbw18   rspline  0.00001,10,0.2,1
kbw19   rspline  0.00001,10,0.2,1
kbw20   rspline  0.00001,10,0.2,1
kbw21   rspline  0.00001,10,0.2,1
kbw22   rspline  0.00001,10,0.2,1

imode   =        0 ; amplitude balancing method used by the reson filters
a1      reson    aInput, kcf*1,               kbw1, imode
a2      reson    aInput, kcf*1.0019054878049, kbw2, imode
a3      reson    aInput, kcf*1.7936737804878, kbw3, imode
a4      reson    aInput, kcf*1.8009908536585, kbw4, imode
a5      reson    aInput, kcf*2.5201981707317, kbw5, imode
a6      reson    aInput, kcf*2.5224085365854, kbw6, imode
a7      reson    aInput, kcf*2.9907012195122, kbw7, imode
a8      reson    aInput, kcf*2.9940548780488, kbw8, imode
a9      reson    aInput, kcf*3.7855182926829, kbw9, imode
a10     reson    aInput, kcf*3.8061737804878, kbw10,imode
a11     reson    aInput, kcf*4.5689024390244, kbw11,imode
a12     reson    aInput, kcf*4.5754573170732, kbw12,imode
a13     reson    aInput, kcf*5.0296493902439, kbw13,imode
a14     reson    aInput, kcf*5.0455030487805, kbw14,imode
a15     reson    aInput, kcf*6.0759908536585, kbw15,imode
a16     reson    aInput, kcf*5.9094512195122, kbw16,imode
a17     reson    aInput, kcf*6.4124237804878, kbw17,imode
a18     reson    aInput, kcf*6.4430640243902, kbw18,imode
a19     reson    aInput, kcf*7.0826219512195, kbw19,imode
a20     reson    aInput, kcf*7.0923780487805, kbw20,imode
a21     reson    aInput, kcf*7.3188262195122, kbw21,imode
a22     reson    aInput, kcf*7.5551829268293, kbw22,imode

; amplitude control for each filter output
kAmp1    rspline  0, 1, 0.3, 1
kAmp2    rspline  0, 1, 0.3, 1
kAmp3    rspline  0, 1, 0.3, 1
kAmp4    rspline  0, 1, 0.3, 1
kAmp5    rspline  0, 1, 0.3, 1
kAmp6    rspline  0, 1, 0.3, 1
kAmp7    rspline  0, 1, 0.3, 1
kAmp8    rspline  0, 1, 0.3, 1
kAmp9    rspline  0, 1, 0.3, 1
kAmp10   rspline  0, 1, 0.3, 1
kAmp11   rspline  0, 1, 0.3, 1
kAmp12   rspline  0, 1, 0.3, 1
kAmp13   rspline  0, 1, 0.3, 1
kAmp14   rspline  0, 1, 0.3, 1
kAmp15   rspline  0, 1, 0.3, 1
kAmp16   rspline  0, 1, 0.3, 1
kAmp17   rspline  0, 1, 0.3, 1
kAmp18   rspline  0, 1, 0.3, 1
kAmp19   rspline  0, 1, 0.3, 1
kAmp20   rspline  0, 1, 0.3, 1
kAmp21   rspline  0, 1, 0.3, 1
kAmp22   rspline  0, 1, 0.3, 1

; left and right channel mixes are created using alternate filter outputs.
; This shall create a stereo effect.
aMixL    sum      a1*kAmp1,a3*kAmp3,a5*kAmp5,a7*kAmp7,a9*kAmp9,a11*kAmp11,\
                        a13*kAmp13,a15*kAmp15,a17*kAmp17,a19*kAmp19,a21*kAmp21
aMixR    sum      a2*kAmp2,a4*kAmp4,a6*kAmp6,a8*kAmp8,a10*kAmp10,a12*kAmp12,\
                        a14*kAmp14,a16*kAmp16,a18*kAmp18,a20*kAmp20,a22*kAmp22

kEnv     linseg   0, p3*0.5, 1,p3*0.5,0,1,0       ; global amplitude envelope
outs   (aMixL*kEnv*0.00008), (aMixR*kEnv*0.00008) ; audio sent to outputs
  endin









;FUNCTION TABLES STORING DATA FOR VARIOUS VOICE FORMANTS

;BASS
giBF1 ftgen 0, 0, -5, -2, 600,   400, 250,   400,  350
giBF2 ftgen 0, 0, -5, -2, 1040, 1620, 1750,  750,  600
giBF3 ftgen 0, 0, -5, -2, 2250, 2400, 2600, 2400, 2400
giBF4 ftgen 0, 0, -5, -2, 2450, 2800, 3050, 2600, 2675
giBF5 ftgen 0, 0, -5, -2, 2750, 3100, 3340, 2900, 2950

giBDb1 ftgen 0, 0, -5, -2,   0,	  0,   0,   0,   0
giBDb2 ftgen 0, 0, -5, -2,  -7,	-12, -30, -11, -20
giBDb3 ftgen 0, 0, -5, -2,  -9,	 -9, -16, -21, -32
giBDb4 ftgen 0, 0, -5, -2,  -9,	-12, -22, -20, -28
giBDb5 ftgen 0, 0, -5, -2, -20,	-18, -28, -40, -36

giBBW1 ftgen 0, 0, -5, -2,  60,  40,  60,  40,  40
giBBW2 ftgen 0, 0, -5, -2,  70,  80,  90,  80,  80
giBBW3 ftgen 0, 0, -5, -2, 110, 100, 100, 100, 100
giBBW4 ftgen 0, 0, -5, -2, 120, 120, 120, 120, 120
giBBW5 ftgen 0, 0, -5, -2, 130, 120, 120, 120, 120

;TENOR
giTF1 ftgen 0, 0, -5, -2,  650,  400,  290,  400,  350
giTF2 ftgen 0, 0, -5, -2, 1080, 1700, 1870,  800,  600
giTF3 ftgen 0, 0, -5, -2, 2650,	2600, 2800, 2600, 2700
giTF4 ftgen 0, 0, -5, -2, 2900,	3200, 3250, 2800, 2900
giTF5 ftgen 0, 0, -5, -2, 3250,	3580, 3540, 3000, 3300

giTDb1 ftgen 0, 0, -5, -2,   0,   0,   0,   0,   0
giTDb2 ftgen 0, 0, -5, -2,  -6, -14, -15, -10, -20
giTDb3 ftgen 0, 0, -5, -2,  -7, -12, -18, -12, -17
giTDb4 ftgen 0, 0, -5, -2,  -8, -14, -20, -12, -14
giTDb5 ftgen 0, 0, -5, -2, -22, -20, -30, -26, -26

giTBW1 ftgen 0, 0, -5, -2,  80,	 70,  40,  40,  40
giTBW2 ftgen 0, 0, -5, -2,  90,	 80,  90,  80,  60
giTBW3 ftgen 0, 0, -5, -2, 120,	100, 100, 100, 100
giTBW4 ftgen 0, 0, -5, -2, 130,	120, 120, 120, 120
giTBW5 ftgen 0, 0, -5, -2, 140,	120, 120, 120, 120

;COUNTER TENOR
giCTF1 ftgen 0, 0, -5, -2,  660,  440,  270,  430,  370
giCTF2 ftgen 0, 0, -5, -2, 1120, 1800, 1850,  820,  630
giCTF3 ftgen 0, 0, -5, -2, 2750, 2700, 2900, 2700, 2750
giCTF4 ftgen 0, 0, -5, -2, 3000, 3000, 3350, 3000, 3000
giCTF5 ftgen 0, 0, -5, -2, 3350, 3300, 3590, 3300, 3400

giTBDb1 ftgen 0, 0, -5, -2,   0,   0,   0,   0,   0
giTBDb2 ftgen 0, 0, -5, -2,  -6, -14, -24, -10, -20
giTBDb3 ftgen 0, 0, -5, -2, -23, -18, -24, -26, -23
giTBDb4 ftgen 0, 0, -5, -2, -24, -20, -36, -22, -30
giTBDb5 ftgen 0, 0, -5, -2, -38, -20, -36, -34, -30

giTBW1 ftgen 0, 0, -5, -2, 80,   70,  40,  40,  40
giTBW2 ftgen 0, 0, -5, -2, 90,   80,  90,  80,  60
giTBW3 ftgen 0, 0, -5, -2, 120, 100, 100, 100, 100
giTBW4 ftgen 0, 0, -5, -2, 130, 120, 120, 120, 120
giTBW5 ftgen 0, 0, -5, -2, 140, 120, 120, 120, 120

;ALTO
giAF1 ftgen 0, 0, -5, -2,  800,  400,  350,  450,  325
giAF2 ftgen 0, 0, -5, -2, 1150, 1600, 1700,  800,  700
giAF3 ftgen 0, 0, -5, -2, 2800, 2700, 2700, 2830, 2530
giAF4 ftgen 0, 0, -5, -2, 3500, 3300, 3700, 3500, 2500
giAF5 ftgen 0, 0, -5, -2, 4950, 4950, 4950, 4950, 4950

giADb1 ftgen 0, 0, -5, -2,   0,   0,   0,   0,   0
giADb2 ftgen 0, 0, -5, -2,  -4, -24, -20,  -9, -12
giADb3 ftgen 0, 0, -5, -2, -20, -30, -30, -16, -30
giADb4 ftgen 0, 0, -5, -2, -36, -35, -36, -28, -40
giADb5 ftgen 0, 0, -5, -2, -60, -60, -60, -55, -64

giABW1 ftgen 0, 0, -5, -2, 50,   60,  50,  70,  50
giABW2 ftgen 0, 0, -5, -2, 60,   80, 100,  80,  60
giABW3 ftgen 0, 0, -5, -2, 170, 120, 120, 100, 170
giABW4 ftgen 0, 0, -5, -2, 180, 150, 150, 130, 180
giABW5 ftgen 0, 0, -5, -2, 200, 200, 200, 135, 200

;SOPRANO
giSF1 ftgen 0, 0, -5, -2,  800,  350,  270,  450,  325
giSF2 ftgen 0, 0, -5, -2, 1150, 2000, 2140,  800,  700
giSF3 ftgen 0, 0, -5, -2, 2900, 2800, 2950, 2830, 2700
giSF4 ftgen 0, 0, -5, -2, 3900, 3600, 3900, 3800, 3800
giSF5 ftgen 0, 0, -5, -2, 4950, 4950, 4950, 4950, 4950

giSDb1 ftgen 0, 0, -5, -2,   0,   0,   0,   0,   0
giSDb2 ftgen 0, 0, -5, -2,  -6, -20, -12, -11, -16
giSDb3 ftgen 0, 0, -5, -2, -32, -15, -26, -22, -35
giSDb4 ftgen 0, 0, -5, -2, -20, -40, -26, -22, -40
giSDb5 ftgen 0, 0, -5, -2, -50, -56, -44, -50, -60

giSBW1 ftgen 0, 0, -5, -2,  80,  60,  60,  70,  50
giSBW2 ftgen 0, 0, -5, -2,  90,  90,  90,  80,  60
giSBW3 ftgen 0, 0, -5, -2, 120, 100, 100, 100, 170
giSBW4 ftgen 0, 0, -5, -2, 130, 150, 120, 130, 180
giSBW5 ftgen 0, 0, -5, -2, 140, 200, 120, 135, 200



instr Sus_voc
  kFund    expon     p4,p3,p5               ; fundamental
  kVow     line      p6,p3,p7               ; vowel select
  kBW      line      p8,p3,p9               ; bandwidth factor
  iVoice   =         p10                    ; voice select
  kSrc     line      p11,p3,p12             ; source mix

  aNoise   pinkish   3                      ; pink noise
  aVCO     vco2      1.2,kFund,2,0.02       ; pulse tone
  aInput   ntrpol    aVCO,aNoise,kSrc       ; input mix

  ; read formant cutoff frequenies from tables
  kCF1     tablei    kVow*5,giBF1+(iVoice*15)
  kCF2     tablei    kVow*5,giBF1+(iVoice*15)+1
  kCF3     tablei    kVow*5,giBF1+(iVoice*15)+2
  kCF4     tablei    kVow*5,giBF1+(iVoice*15)+3
  kCF5     tablei    kVow*5,giBF1+(iVoice*15)+4
  ; read formant intensity values from tables
  kDB1     tablei    kVow*5,giBF1+(iVoice*15)+5
  kDB2     tablei    kVow*5,giBF1+(iVoice*15)+6
  kDB3     tablei    kVow*5,giBF1+(iVoice*15)+7
  kDB4     tablei    kVow*5,giBF1+(iVoice*15)+8
  kDB5     tablei    kVow*5,giBF1+(iVoice*15)+9
  ; read formant bandwidths from tables
  kBW1     tablei    kVow*5,giBF1+(iVoice*15)+10
  kBW2     tablei    kVow*5,giBF1+(iVoice*15)+11
  kBW3     tablei    kVow*5,giBF1+(iVoice*15)+12
  kBW4     tablei    kVow*5,giBF1+(iVoice*15)+13
  kBW5     tablei    kVow*5,giBF1+(iVoice*15)+14
  ; create resonant formants byt filtering source sound
  aForm1   reson     aInput, kCF1, kBW1*kBW, 1     ; formant 1
  aForm2   reson     aInput, kCF2, kBW2*kBW, 1     ; formant 2
  aForm3   reson     aInput, kCF3, kBW3*kBW, 1     ; formant 3
  aForm4   reson     aInput, kCF4, kBW4*kBW, 1     ; formant 4
  aForm5   reson     aInput, kCF5, kBW5*kBW, 1     ; formant 5

  ; formants are mixed and multiplied both by intensity values derived from tables and by the on-screen gain controls for each formant
  aMix     sum       aForm1*ampdbfs(kDB1),aForm2*ampdbfs(kDB2),aForm3*ampdbfs(kDB3),aForm4*ampdbfs(kDB4),aForm5*ampdbfs(kDB5)
  kEnv     linseg    0,3,1,p3-6,1,3,0     ; an amplitude envelope
           outs      aMix*kEnv, aMix*kEnv ; send audio to outputs
endin



; ================================================
; reverb
; ================================================
instr Reverb

  ;ip3_max_dur chnget "p3_max_dur"
  ;p3 = ip3_max_dur
  ;print p3
  ;chnset 0, "p3_max_dur"
  arevL, arevR    reverbsc    garevL, garevR,  pSelector_k(p4,  0,     0.999, 0), pSelector_k(p5,  20,     20000, 0)
  ;arevL    buthp     arevL, 3000
  ;arevR    buthp     arevR, 3000
          
            out     arevL, arevR

  clear garevL, garevR

endin

</CsInstruments>

<CsScore>
##REPLACE_WITH_SCORE##
/*
i "Sus_LHBP"    0     20    150 0 1

s

;   instr   start  dur   amp    freq     amp*    freq*   pan   rev   fn  phase    
i "Aditiva"   0     8   0.40     440    [1/1]       1    0.5   0.4   -1      0
i "Aditiva"   .     .      .       .    [1/2]       2      .     .    .      .
i "Aditiva"   .     .      .       .    [1/3]       3      .     .    .      .
i "Aditiva"   .     .      .       .    [1/4]       4      .     .    .      .
i "Aditiva"   .     .      .       .    [1/5]       5      .     .    .      .
i "Aditiva"   .     .      .       .    [1/6]       6      .     .    .      .
i "Aditiva"   .     .      .       .    [1/7]       7      .     .    .      .
i "Aditiva"   .     .      .       .    [1/8]       8      .     .    .      .

;   instr   start  dur  room  cutoff
i "Reverb"    0     9   0.60   12000

;   instr   start  dur   amp    freq     amp*    freq*   pan   rev   fn  phase    
i "Aditiva"   9     8   0.40     440       1        1    0.5   0.4   -1      0
i "Aditiva"   .     8   0.34     480
i "Aditiva"   .     8   0.29     500
i "Aditiva"   .     8   0.26     539
i "Aditiva"   .     8   0.21     580
i "Aditiva"   .     8   0.20     600
i "Aditiva"   .     8   0.16     660
i "Aditiva"   .     8   0.12     720

;   instr   start  dur  room  cutoff
i "Reverb"    9    18   0.60   12000


s
;  n t size GEN   val1   ext1   val2    ext2     val3   ext3    val4
f  1 0 4097  -5  0.001    600    0.1    2997      0.1    500   0.001
f  2 0 4097  -5    440   2000    523    2097      220
f  5 0 4097  -7      0   2000      1    2097        0
f 20 0 4097  -7      0   4000   0.92      97        0

;   instr   start   dur   amp   freq     amp*    freq*   pan     rev   fn   phase    
i "Aditiva"   0      8     -1     -2       1        1     -5      -5
i "Aditiva"   .      .      .      .    0.75     1.20
i "Aditiva"   .      .      .      .    0.50     1.30
i "Aditiva"   .      .      .      .    0.66     2.44
i "Aditiva"   .      .      .      .    0.40     1.70
i "Aditiva"   .      .      .      .    0.28     1.90
i "Aditiva"   .      .      .      .    0.20     2.03
i "Aditiva"   .      .      .      .    0.15     2.11

i "Reverb"    0      9    -20  12000


s

;p4  = oscillator frequency
;oscillator 1
;p5  = amplitude
;p6  = type (1=sawtooth,2=square-PWM,3=noise)
;p7  = PWM (square wave only)
;p8  = octave displacement
;p9  = tuning displacement (cents)
;oscillator 2
;p10 = amplitude
;p11 = type (1=sawtooth,2=square-PWM,3=noise)
;p12 = pwm (square wave only)
;p13 = octave displacement
;p14 = tuning displacement (cents)
;global filter envelope
;p15 = cutoff
;p16 = attack time
;p17 = decay time
;p18 = sustain level (fraction of cutoff)
;p19 = release time
;p20 = resonance
;global amplitude envelope
;p21 = attack time
;p22 = decay time
;p23 = sustain level
;p24 = release time
; p1 p2 p3  p4 p5  p6 p7   p8 p9  p10 p11 p12 p13
;p14 p15 p16  p17  p18  p19 p20 p21  p22 p23 p24
i "Sus_LP"  0  1   50 0   2  .5   0  -5  0   2   0.5 0   \
 5   12  .01  2    .01  .1  0   .005 .01 1   .05
i "Sus_LP"  +  1   50 .2  2  .5   0  -5  .2  2   0.5 0   \
 5   1   .01  1    .1   .1  .5  .005 .01 1   .05
i "Sus_LP"  +  1   50 .2  2  .5   0  -8  .2  2   0.5 0   \
 8   3   .01  1    .1   .1  .5  .005 .01 1   .05
i "Sus_LP"  +  1   50 .2  2  .5   0  -8  .2  2   0.5 -1  \
 8   7  .01   1    .1   .1  .5  .005 .01 1   .05
i "Sus_LP"  +  3   50 .2  1  .5   0  -10 .2  1   0.5 -2  \
 10  40  .01  3    .001 .1  .5  .005 .01 1   .05
i "Sus_LP"  +  10  50 1   2  .01  -2 0   .2  3   0.5 0   \
 0   40  5    5    .001 1.5 .1  .005 .01 1   .05

s


;i "Sus_LHBP_trig" 0 10

i "Sus_LHBP"    0     5     154.057
i "Sus_LHBP"    6     20    151.395

s

;         p4  p5  p6  p7  p8  p9 p10 p11  p12
i "Sus_voc" 0  10 50  100 0   1   2   0  0   0    0
i "Sus_voc"  8  .  78  77  1   0   1   0  1   0    0
i "Sus_voc"  16 .  150 118 0   1   1   0  2   1    1
i "Sus_voc"  24 .  200 220 1   0   0.2 0  3   1    0
i "Sus_voc"  32 .  400 800 0   1   0.2 0  4   0    1

s

; envolventes de amplitud e índice de modulación =================
;n  inicio  tamaño  GEN   a    n1      b      n2      c    n3     d    n4    e

; caída exponencial dos segmentos lineales
f2    0     8192     7    1   2000   .25     6192     0

; caída exponencial tres segmentos lineales
f3    0     8192     7    1   1170    .5     1404   .25   5618    0

; caída exponencial tres segmentos lineales
f4    0     8192     7    1   1170    .4     1404    .2   5618    0

; caída exponencial modificada
f5    0     8192     7   .9    952    .5     1334     1   2286   .3   3620   0



; envolventes de índice de modulación ============================
;n  inicio  tamaño  GEN   a    n1      b      n2     c 

; ataque y caída lentas
f6    0     8192     7    0   2458     1     4096    0

; caída corta
f7    0     8192     7    1    550     0



; p2    =   tiempo de inicio
; p3    =   duración total 
; p4    =   amplitud
; p5    =   frecuencia portante
; p6    =   frecuencia modulante
; p7    =   índice de modulación máximo
; p8    =   índice de modulación mínimo
; p9    =   función de envolvente de intensidad
; p10   =   función de envolvente de índice de modulación
; p11   =   envío a la reverberación




;   p1      p2     p3   p4    p5   p6      p7     p8      p9      p10     p11
; instr inicio    dur  amp     c    m   indx1  indx0  ampenv  indxenv revsend
i   1    0.584   .015  -28  5950    1       0      0       3        2     .12
i   1    0.610     .   -29
i   1    0.662     .   -30
i   1    0.689     .   -28  6300
i   1    0.716     .   -30  5950
i   1    0.743     .   -31  5610
i   1    0.770     .   -30  6300
i   1    0.799     .    .   5950
i   1    0.828     .   -28
i   1    0.856    .02   .
i   1    0.917     .    .
i   1    0.947     .   -30
i   1    1.008     .    .
i   1    1.040     .   -27  5620
i   1    1.072     .   -29
i   1    1.105     .   
i   1    1.173     .    .   5950
i   1    1.242   .025  -30
i   1    1.277     .    .   6300
i   1    1.313     .   -32  5620
i   1    1.349     .    .   6300
i   1    1.386     .    .   5950
i   1    1.462     .    .   5620
i   1    1.540     .    .   5950
i   1    1.580     .    .   5620
i   1    1.660    .03
i   1    1.703     .    .   5950
i   1    1.788     .   -28  6300
i   1    1.831     .   -30  5950
i   1    1.875     .   -28  5600
i   1    1.920     .   -30  5300
i   1    2.012     .   -31
i   1    2.059     .    .   5950
i   1    2.107   .035   .   5300
i   1    2.155     .    .   5000
i   1    2.204     .    .   5950
i   1    2.254     .    .   5300
i   1    2.304     .    .   5000
i   1    2.355
i   1    2.514     .    .   5610
i   1    2.568     .    .   5300
i   1    2.623     .    .   5000
i   1    2.736     .   -30  6300
i   1    2.794    .04   .   5300
i   1    2.853     .    .   4990
i   1    2.972     .   -29  5600
i   1    3.033     .    .   5620
i   1    3.095     .    .   4720
i   1    3.158     .    .   5610
i   1    3.287     .    .   5000
i   1    3.353     .    .   6300
i   1    3.420   .045   .   5950
i   1    3.488     .    .   5000
i   1    3.557     .    .   
i   1    3.699    .05   .   5950
i   1    3.843   .045  -30  6300
i   1    3.918     .   -31  5610
i   1    3.994     .    .   4450
i   1    4.071     .    .   5950
i   1    4.149    .05   .   4450
i   1    4.228     .    .   5620
i   1    4.389     .   -32  5000
i   1    4.556     .    .   4720
i   1    4.641
i   1    4.726     .    .   5300
i   1    4.814   .055   .   5000
i   1    4.993     .    .   4720
i   1    5.178     .    .   6300
i   1    5.272     .   -31  4200
i   1    5.368     .    .   5000
i   1    5.464     .   -30  4460
i   1    5.663     .   -28  6700    .       .      .       .        .     .05
i   1    5.763    .06   .   5000
i   1    5.863     .    .   4750
i   1    5.963     .    .   5630
i   1    6.063     .   -29
i   1    6.163     .    .   4470
i   1    6.263     .    .   4210
i   1    6.462   .065  -32
i   1    6.563     .    .   5030
i   1    6.762     .   -30  7100
i   1    6.862     .    .   4750
i   1    6.962     .    .   4230
i   1    7.062    .07   .   5020
i   1    7.162     .    .   4230
i   1    7.362     .    .   5980
i   1    7.462     .   -32  6700
i   1    7.861     .   -31  4220
i   1    7.961     .   -28  7100
i   1    8.061   .075   .   4730
i   1    8.261     .    .   3550
i   1    8.361     .   -26  6720
i   1    8.460     .   -27  5030
i   1    8.560     .    <   6720
i   1    8.660     .    <   3160
i   1    8.760     .    <   3770
i   1    8.860    .08   <   6320
i   1    8.960     .    <   3350
i   1    9.060     .    <   5330
i   1    9.157     .   -32  6340
i   1    9.260     .    <
i   1    9.360     .    <   5020
i   1    9.459     .    <   2820
i   1    9.559     .   -29  4480    .       .      .       .        .     .03
i   1    9.659   .085   .   4230
i   1    9.757     .    .   5990
i   1    9.859     .    .   6720
i   1    9.959     .    .   6340
i   1   10.059     .    .   5330
i   1   10.159     .    .   3170
i   1   10.259     .    .   7120
i   1   10.358     .    .   5330
i   1   10.458     .    .   2510
i   1   10.558     .   -26  3760
i   1   10.656     .    .   2980
i   1   10.758     .    .   2515
i   1   10.858     .   -23  7520
i   1   10.958     .    .   7100
i   1   11.058     .    .   5630
i   1   11.157     .   -25  3350
i   1   11.257     .    <   2810
i   1   11.457     .    <   4215
i   1   11.555     .    <   2980
i   1   11.657     .    <   2650
i   1   11.757     .   -27  2980
i   1   11.857     .    .   4465
i   1   11.957     .    .   3540
i   1   12.057     .    .   4720
i   1   12.156     .    .   3970
i   1   12.256     .    .   5955
i   1   12.356     .   -25  7080
i   1   12.456     .    .   7500
i   1   12.556     .    .   7075
i   1   12.653     .    .   6300
i   1   12.756     .    .   3970
i   1   12.856     .    .   5300
i   1   12.956     .    .   4450
i   1   13.055     .   -26  1980
i   1   13.155     .    <   3740
i   1   13.255     .    <   3150
i   1   13.355     .    <   4450
i   1   13.455     .   -23  3530
i   1   13.539    .05  -27  2800
i   1   13.589    .07  -25  7740
i   1   13.654    .09  -24  5020  0.993    .1      .       .        .      .1
i   1   13.738     .   -26  2030  0.986     <
i   1   13.850     .   -24  4088  0.978     <
i   1   13.998    .13   .   4545  0.968     <
i   1   14.195     .    .   3300  0.944    .4
i   1   14.462    .18   .   4920  0.940     1
i   1   14.538    .08  -26  3340  0.975    .3     .        .        .     .05
i   1   14.588    .07  -28  2315  0.985    .1
i   1   14.649    .08  -26  1906  0.990    .1
i   1   14.722    .09  -24  6615  0.990    .1
i   1   14.813    .15  -24  5080  0.988    .1     .        .        .      .1
i   1   14.830    .23  -22  1963  0.918     2
i   1   14.925    .12  -24  2587  1.047    .3
i   1   15.063     .2  -24  3478  0.976    .4
i   1   15.235    .15   .   2606  0.969    .5
i   1   15.351    .45  -19  1953  0.889     2
i   1   15.449    .35  -26  1910  0.955
i   1   15.718     .4  -25  1646  0.948   1.6
i   1   16.061    .35  -24  1540  0.935   1.5
i   1   16.121     .6  -18  1225  0.849   4
i   1   16.504     .   -21  3139  0.916


; campanadas
i   1   17.088     .7  -22  1278  0.896    2.5     0       4        4     .05
i   1   17.338    1.5  -18   592  0.793     6      .       .        .      .1
i   1   17.880    1.3  -17  1718  0.867     4      .       2        2     .05
i   1       19    1.7  -18   866  0.830     4      0       4        4      .1
i   1   19.505      3  -16   162  0.291     8      .       .        .
i   1   20.691      3  -19 504.8  0.779     6      .       4        4
i   1   23.558      4  -20    64  0.291     8      .       3        3
i   1   24.521      7  -17   247  0.708
i   1   29.733      9  -18   165  0.708


; tam-tam
i   1   39.723     21  -16  87.4  0.708    5.9     0       2        6      .5


; bajada de percusión
i   1   47.714    .04  -24  8390    1       0      0       5        7      .1   ; 1
i   1   47.764     .    .   8830    .       .      .       .        .       <   ; 2
i   1   47.815     .   -27  9820    .       .      .       .        .       <   ; 3
i   1   47.866     .   -23  7710    .       .      .       .        .       <   ; 4
i   1    47.92     .    .   6400    .       .      .       .        .       <   ; 5
i   1   47.975     .    .   5960    .       .      .       .        .       <   ; 6
i   1   48.031     .    .   6215    .       .      .       .        .       <   ; 7
i   1   48.089     .    .   6854    .       .      .       .        .       <   ; 8
i   1   48.148     .    .   6345    .       .      .       .        .       <   ; 9
i   1   48.208     .    .   4393  1.436     .1     .       .        .       <   ; 10
i   1    48.27     .    .   5410  1.202     <      .       .        .       <   ; 11
i   1   48.333     .    .   5280  1.257     .      .       .        .       <   ; 12
i   1   48.398     .    .   4852  1.516     .      .       .        .       <   ; 13
i   1   48.465     .    .   3146  1.258     .      .       .        .       <   ; 14
i   1   48.533     .    .   2718  1.812     .      .       .        .       <   ; 15
i   1   48.603     .    .   2951  1.341     .      .       .        .       <   ; 16
i   1   48.674    .05  -21  2262  1.885     .      .       .        .     .05   ; 17
i   1   48.746    .06   .   3080  2.053     .      .       .        .       <   ; 18
i   1   48.821    .06  -20  1978  2.473     .      .       .        .       <   ; 19
i   1   48.898    .06   .   2532  2.202     .      .       .        .       <   ; 20
i   1   48.978    .06   .   2288  2.288     .      .       .        .       <   ; 21
i   1   49.058    .06   .   1946  2.432     .      .       .        .       <   ; 22
i   1   49.141    .06   .   1310  1.747     .      .       .        .       <   ; 23
i   1   49.225    .06   .   1568  2.240     .      .       .        .       <   ; 24
i   1   49.311    .06  -19  1487  2.288     .      .       .        .       <   ; 25
i   1   49.401    .07   .   1116  3.302     .      .       .        .       <   ; 26
i   1   49.491    .07   .    938  3.201     .      .       .        .       <   ; 27
i   1   49.585    .07   .    990  3.094     .      .       .        .       <   ; 28
i   1    49.68    .07   .    782  3.019     .      .       .        .       <   ; 29
i   1   49.778    .07  -18   822  2.905     .      .       .        .       <   ; 30
i   1   49.878    .07   .    725  2.810     .      .       .        .       <   ; 31
i   1   49.981    .07   .    537  2.620     .      .       .        .       <   ; 32
i   1   50.087    .08  -17   560  2.074     .      .       .        .       <   ; 33
i   1   50.195    .08   .    420  2.049     .      .       .        .       <   ; 34
i   1   50.306    .07   .    405  2.025     .      .       .        .       <   ; 35
i   1   50.420    .07  -16   267  1.780     .      .       .        .       <   ; 36
i   1   50.536    .07  -18   334  1.758     .      .       .        .       <   ; 37
i   1   50.655    .08  -16   230  1.643     .      .       .        .       <   ; 38
i   1   50.778    .09  -12   165  1.473     .      .       .        .       <   ; 39
i   1   50.904    .10  -11   205  1.464     .      .       .        .       <   ; 40
i   1   51.033    .10   .    190  1.462     .      .       .        .       <   ; 41
i   1   51.165    .11  -10   155  1.372     .      .       .        .       <   ; 42
i   1   51.301    .12   -9    94  1.382     .      .       .        .       <   ; 43
i   1    51.44    .12   -8    86  1.387     .      .       .        .       <   ; 44
i   1    51.58    .12   -3    90  1.406     18     .       .        .     .01   ; 45


;  instr    start  dur  room  cutoff
i "Reverb"    0     60  0.60   12000


*/
</CsScore>

</CsoundSynthesizer>



