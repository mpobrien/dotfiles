function inspect(o,i){
    if(typeof i=='undefined')i='';
    if(i.length>50)return '[MAX ITERATIONS]';
    var r=[];
    for(var p in o){
        var t=typeof o[p];
        r.push(i+'"'+p+'" ('+t+') => '+(t=='object' ? 'object:'+inspect(o[p],i+'  ') : o[p]+''));
    }
    return r.join(i+'\n');
}

function randint(min, max){
    return min + Math.floor(Math.random() * (max - min + 1));
}
