
**free

// FOMS001 - Financial Transaction Reader
// Interactive transaction lookup using embedded SQL

ctl-opt dftactgrp(*no) actgrp(*new);

// Host variables
dcl-s txnId       int(10);
dcl-s amount      packed(15:2);
dcl-s txnType     char(1);
dcl-s txnStatus   char(1);
dcl-c PROGRAM_VERSION '0.2.1';

// User input
dcl-s userInput   char(10);
dcl-s pauseInput  char(1);
dcl-s exitProgram ind inz(*off);

// Display program version
dsply ('FOMS001 - Version ' + PROGRAM_VERSION);

// Main loop
dow not exitProgram;

   clear userInput;

   dsply 'Transaction ID (0=Exit):' ' ' userInput;

   // Validate input
   userInput = %trim(userInput);

   if userInput = '0';
      exitProgram = *on;
      iter;
   endif;

   if %trim(userInput) = ''
   or %check('0123456789': %trim(userInput)) <> 0;

      dsply 'Invalid transaction ID';
      iter;
   endif;

   // Convert input to numeric ID
   monitor;
      txnId = %int(%trim(userInput));
   on-error;
      dsply 'Invalid transaction ID';
      iter;
   endmon;

   if txnId <= 0;
      dsply 'Transaction ID must be positive';
      iter;
   endif;

   // Retrieve transaction from DB2
   exec sql
      SELECT AMOUNT, TXN_TYPE, STATUS
        INTO :amount, :txnType, :txnStatus
        FROM MGHIGLIA1.FOMSTXN
       WHERE TXN_ID = :txnId;

   // Check SQL result
   select;
      when SQLSTATE = '00000';
         dsply ('Transaction: ' + %char(txnId));
         dsply ('Amount: ' + %char(amount));
         dsply ('Type: ' + txnType);
         dsply ('Status: ' + txnStatus);

      when SQLSTATE = '02000';
         dsply 'Transaction not found';

      other;
         dsply ('SQL error: ' + SQLSTATE);
   endsl;

   clear pauseInput;
   dsply 'Enter a character to continue' '' pauseInput;

enddo;

dsply 'FOMS001 ended';

*inlr = *on;
