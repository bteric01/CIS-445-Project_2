****************************************************************;
******             DECISION TREE SCORING CODE             ******;
****************************************************************;
 
******         LENGTHS OF NEW CHARACTER VARIABLES         ******;
LENGTH F_WidgBuy  $    3;
LENGTH I_WidgBuy  $    3;
LENGTH U_WidgBuy  $    3;
LENGTH _WARN_  $    4;
 
******              LABELS FOR NEW VARIABLES              ******;
LABEL _NODE_  = 'Node' ;
LABEL _LEAF_  = 'Leaf' ;
LABEL P_WidgBuyYes  = 'Predicted: WidgBuy=Yes' ;
LABEL P_WidgBuyNo  = 'Predicted: WidgBuy=No' ;
LABEL Q_WidgBuyYes  = 'Unadjusted P: WidgBuy=Yes' ;
LABEL Q_WidgBuyNo  = 'Unadjusted P: WidgBuy=No' ;
LABEL R_WidgBuyYes  = 'Residual: WidgBuy=Yes' ;
LABEL R_WidgBuyNo  = 'Residual: WidgBuy=No' ;
LABEL F_WidgBuy  = 'From: WidgBuy' ;
LABEL I_WidgBuy  = 'Into: WidgBuy' ;
LABEL U_WidgBuy  = 'Unnormalized Into: WidgBuy' ;
LABEL _WARN_  = 'Warnings' ;
 
 
******      TEMPORARY VARIABLES FOR FORMATTED VALUES      ******;
LENGTH _ARBFMT_3 $      3; DROP _ARBFMT_3;
_ARBFMT_3 = ' '; /* Initialize to avoid warning. */
LENGTH _ARBFMT_4 $      4; DROP _ARBFMT_4;
_ARBFMT_4 = ' '; /* Initialize to avoid warning. */
 
 
_ARBFMT_3 = PUT( WidgBuy , $3.);
 %DMNORMCP( _ARBFMT_3, F_WidgBuy );
 
******             ASSIGN OBSERVATION TO NODE             ******;
_ARBFMT_4 = PUT( Income , $4.);
 %DMNORMIP( _ARBFMT_4);
IF _ARBFMT_4 IN ('LOW' ) THEN DO;
  _NODE_  =                    3;
  _LEAF_  =                    3;
  P_WidgBuyYes  =     0.88888888888888;
  P_WidgBuyNo  =     0.11111111111111;
  Q_WidgBuyYes  =     0.88888888888888;
  Q_WidgBuyNo  =     0.11111111111111;
  I_WidgBuy  = 'YES' ;
  U_WidgBuy  = 'Yes' ;
  END;
ELSE DO;
  IF  NOT MISSING(Age ) AND
    Age  <                 30.5 THEN DO;
    _NODE_  =                    4;
    _LEAF_  =                    1;
    P_WidgBuyYes  =                  0.6;
    P_WidgBuyNo  =                  0.4;
    Q_WidgBuyYes  =                  0.6;
    Q_WidgBuyNo  =                  0.4;
    I_WidgBuy  = 'YES' ;
    U_WidgBuy  = 'Yes' ;
    END;
  ELSE DO;
    _NODE_  =                    5;
    _LEAF_  =                    2;
    P_WidgBuyYes  =                    0;
    P_WidgBuyNo  =                    1;
    Q_WidgBuyYes  =                    0;
    Q_WidgBuyNo  =                    1;
    I_WidgBuy  = 'NO' ;
    U_WidgBuy  = 'No' ;
    END;
  END;
 
*****  RESIDUALS R_ *************;
IF  F_WidgBuy  NE 'YES'
AND F_WidgBuy  NE 'NO'  THEN DO;
        R_WidgBuyYes  = .;
        R_WidgBuyNo  = .;
 END;
 ELSE DO;
       R_WidgBuyYes  =  -P_WidgBuyYes ;
       R_WidgBuyNo  =  -P_WidgBuyNo ;
       SELECT( F_WidgBuy  );
          WHEN( 'YES'  ) R_WidgBuyYes  = R_WidgBuyYes  +1;
          WHEN( 'NO'  ) R_WidgBuyNo  = R_WidgBuyNo  +1;
       END;
 END;
 
****************************************************************;
******          END OF DECISION TREE SCORING CODE         ******;
****************************************************************;
 
drop _LEAF_;
