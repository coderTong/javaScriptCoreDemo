function blockSum(a,b){
    var num = 99;
    function blockS(){
        return a+b+num;
    }
    return blockS;
}
blockSum(5,6)();