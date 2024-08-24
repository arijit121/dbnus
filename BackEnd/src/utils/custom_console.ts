export class CustomConsole {

    static infoLog(massage: string, options?: { tag?: string }) {
        const { tag } = options || {};
        console.log(`\x1B[34m💡 [${typeof tag !== 'undefined' ? tag : "dbnus"}]::==>> ${massage}\x1B[0m`,);
    }
    static debugLog(massage: string, options?: { tag?: string }) {
        const { tag } = options || {};
        console.log(`\x1B[33m✒️ [${typeof tag !== 'undefined' ? tag : "dbnus"}]::==>> ${massage}\x1B[0m`,);
    }
    static errorLog(massage: string, options?: { tag?: string }) {
        const { tag } = options || {};
        console.log(`\x1B[31m🚫 [${typeof tag !== 'undefined' ? tag : "dbnus"}]::==>> ${massage}\x1B[0m`,);
    }
}