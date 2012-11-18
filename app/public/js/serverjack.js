var eventGridHTML='<div class="events" id="event_$eventId" onclick="openRegistration(\'$eventUrl\;)"><table><tr><div id="name_box">$eventName</div></tr><tr><br/></tr><tr><div id="image_box" width="200"><img src="$eventImg" alt="Profile pic" width="240" height="240" /></div></tr><tr><div id="description_box" width="200"><p >Type: $evenType &nbsp; Date:$eventDate &nbsp; Location:$eventLocation </p><p >$evenDesc </p></div></tr></table></div>';

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
	$.getJSON('/events?type='+hardLevel,function(data){
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
		});
		
		
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