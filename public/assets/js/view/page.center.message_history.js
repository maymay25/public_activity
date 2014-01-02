require(['jquery','underscore','page','../view/page.center'], function( $, _, Page){

	var $preInput = $("#preInput"),
			$publishBox = $("#publishBox"),
			$publishInput = $("#publishInput");

	$preInput.bind('click',function(){
		$publishBox.addClass('active');
		$publishInput.focus();
	});

	function send_private_chat(ele){
		var $ele = $(ele),
				uid = $ele.attr('uid'),
				content = $publishInput.val();

		if(content&&content.trim()){
			window.chatTo(null,{
				uid:uid,
				content:content
			},function(){
				$publishInput.val('');
				$publishBox.removeClass('active');
			});
		}else{
			Page.shine($publishInput);
			$publishInput.focus();
			return false;
		}
	};

	// TODO 加入实时聊天 faye代码
	
	

	window.send_private_chat = send_private_chat;

})