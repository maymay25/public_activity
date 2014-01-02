function Music() {
    this.init();
}
(function () {
    var pages = [],
        panels = [],
        selectedItem = null;
    Music.prototype = {
        init:function () {
            var me = this;
        },
        _getHtml:function () {
            var music_id = $G('J_music_id').value,
                music_type = $G('J_music_source').value;

            if(''+music_id==''){
                alert('未指定声音id');
                return ''
            }

            if(music_type=="ximalaya"){
                return '<embed src="http://s1.xmcdn.com/js/player.swf?id='+music_id+'" type="application/x-shockwave-flash" width="257" height="33" wmode="transparent"></embed>'
            }else{
                return '<embed src="http://www.xiami.com/widget/0_'+music_id+'/singlePlayer.swf" type="application/x-shockwave-flash" width="257" height="33" wmode="transparent"></embed>'    
            }
        },
        exec:function () {
            var me = this;
            editor.execCommand('music', {
                html:me._getHtml()
            });
        }
    };
})();



