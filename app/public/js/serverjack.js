//var eventGridHTML='<div class="events" id="event_$eventId" onclick="openRegistration(\'$eventUrl\;)"><table><tr><div id="name_box">$eventName</div></tr><tr><br/></tr><tr><div id="image_box" width="200"><img src="$eventImg" alt="Profile pic" width="240" height="240" /></div></tr><tr><div id="description_box" width="200"><p >Type: $evenType &nbsp; Date:$eventDate &nbsp; Location:$eventLocation </p><p >$evenDesc </p></div></tr></table></div>';
var eventGridHTML='<a href="javascript:void(0)" onclick="openRegistration(\'$eventUrl\')"><div class="polaroid" id="$eventId" style="display:none;"  ><p  class="head" style="background-color:#000;opacity:0.8;display:none;">$evenDesc</p><p ><span style="font-size:15px;color:#f6931f"> $eventName : $evenType </span> <br/> $eventDate, $eventLocation </p><img src="$eventImg" /></div></a>';

var timeFrame={
		WEEK:"WEEK",
		MONTH1:"1MONTH",
		MONTH3:"3MONTH"
};

var activity={
		RUNNING:"RUNNING",
		BIKING:"BIKING"
}

function mapEvents(eventTimeFrame,activityType){
	var result=((activityType==activity.RUNNING)?"#running-events":"#biking-events");
	eventTimeFrame=eventTimeFrame.toUpperCase();
	if(eventTimeFrame==timeFrame.WEEK){
		return result+" > .now";
	}else if(eventTimeFrame==timeFrame.MONTH1){
		return result+" > .month1";
	}else if(eventTimeFrame==timeFrame.MONTH3){
		return result+" > .month3";
	}else{
		alert("Mismatch!!");
	}
	return "";
	
}
//Load the grid data
function filterGrid(hardLevel){
	//'/events?type='+hardLevel
	$.getJSON("response.json",function(data){
		$.each(data,function(index,eventInfo){
			$(mapEvents(eventInfo.time_frame,eventInfo.activity_type)).append(eventGridHTML.replace("$eventName",eventInfo.name)
					.replace("$eventImg",eventInfo.image_url)
					.replace("$evenType",eventInfo.classification)
					.replace("$evenDesc",eventInfo.description)
					.replace("$eventId",eventInfo.id)
					.replace("$eventDate",eventInfo.date)
					.replace("$eventUrl",eventInfo.url)
					.replace("$eventLocation",eventInfo.location)
					);
			$('#'+eventInfo.id).fadeIn(500);
			
		});
		eventCallBack();
		
	});
}

//Load the user details

function loadUser(){
	$.getJSON('user.json',function(data){
		row=data[0];
		$('#profile-avatar').attr("src",row.avatar);
		$('#profile-user').html(row.name);
		
	});
}

function openRegistration(url,txt){
	
	// get the screen height and width  
	var maskHeight = $(document).height();  
	var maskWidth = $(window).width();
	
	// calculate the values for center alignment
	var dialogTop =  (maskHeight/3) - ($('#dialog-box').height());  
	var dialogLeft = (maskWidth/2) - ($('#dialog-box').width()/2); 
	
	// assign values to the overlay and dialog box
	$('#dialog-overlay').css({height:maskHeight, width:maskWidth}).show();
	$('#dialog-box').css({top:dialogTop, left:dialogLeft}).show();
	
	// display the message
	$('#dialog-message').html('<div style="font-size:15px;"> Congratulations !! You have signed for the event! <a href="#" style="color:#000;">Click Here</a> to learn more about the event.</div>');
	
	// if user clicked on button, the overlay layer or the dialogbox, close the dialog	
	$('a.btn-ok, #dialog-overlay, #dialog-box').click(function () {		
		$('#dialog-overlay, #dialog-box').hide();		
		return false;
	});
	
	// if user resize the window, call the same function again
	// to make sure the overlay fills the screen and dialogbox aligned to center	
	$(window).resize(function () {
		
		//only do it if the dialog box is not hidden
		if (!$('#dialog-box').is(':hidden')) popup();		
	});	
}
