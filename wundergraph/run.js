const { register } = require('esbuild-register/dist/node');
const { join } = require('path');

register();

const hookPath = join(__dirname, './.wundergraph/new_hook/auth/demo');

// console.log日志
const logs = [];
let result;
var log = console.log;
// 重写console.log
console.log = function () {
    logs.push([...arguments]);
};

const init = async () => {
    try {
        //await require(hookPath).default();
        result = await require(hookPath).default();
    } catch (e) {
        result = e;
    }
    log(
        JSON.stringify({
            logs,
            result,
        })
    );
};

init();
