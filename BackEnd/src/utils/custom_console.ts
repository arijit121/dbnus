export class CustomConsole {
  
    static  infoLog(massage: string,  tag?: string) {
       console.log(`\x1B[34m💡 [${typeof tag !== 'undefined'?tag:"dbnus"}]::==>> ${massage}\x1B[0m`,);
    }
    static debugLog(massage: string,  tag?: string) {
        console.log(`\x1B[33m✒️ [${typeof tag !== 'undefined'?tag:"dbnus"}]::==>> ${massage}\x1B[0m`,);
    }
    static errorLog(massage: string,  tag?: string) {
        console.log(`\x1B[31m🚫 [${typeof tag !== 'undefined'?tag:"dbnus"}]::==>> ${massage}\x1B[0m`,);
      }
}