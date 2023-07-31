function neighbors(){
    let memo = {};

    return function(x){
        let hash = x.toString();
        if(!(hash in memo)){
            memo[hash] = [[x[0] -1, x[1]],
            [x[0] + 1, x[1]],
            [x[0], x[1] - 1],
            [x[0], x[1] + 1]];
        }
        return memo[hash];
    }
}
const get_neighbors = neighbors();
console.log(get_neighbors([ 2, 3 ]));
console.log(get_neighbors([ 1, 4 ]));
console.log(get_neighbors([ 2, 3 ]));
