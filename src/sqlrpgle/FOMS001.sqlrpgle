
**free

// FOMS001 - Financial Transaction Reader
// Read a transaction from DB2 using embedded SQL

ctl-opt dftactgrp(*no) actgrp(*new);

// Host variables
dcl-s txnId       int(10) inz(1);
dcl-s amount      packed(15:2);
dcl-s txnType     char(1);
dcl-s txnStatus   char(1);
dcl-s userInput char(1);
// dcl-s sqlState    char(5);

// Retrieve transaction
exec sql
   SELECT AMOUNT, TXN_TYPE, STATUS
     INTO :amount, :txnType, :txnStatus
     FROM MGHIGLIA1.FOMSTXN
    WHERE TXN_ID = :txnId;

// Check SQL result
// sqlState = SQLSTATE;

select;
   when sqlState = '00000';
      dsply ('Transaction: ' + %char(txnId));
      dsply ('Amount: ' + %char(amount));
      dsply ('Type: ' + txnType);
      dsply ('Status: ' + txnStatus);

   when sqlState = '02000';
      dsply 'Transaction not found';

   other;
      dsply ('SQL error: ' + sqlState);
endsl;

dsply 'Press Enter to exit' '' userInput;
*inlr = *on;
