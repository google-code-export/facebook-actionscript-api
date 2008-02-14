package com.pbking.facebook.delegates.users
{
	import com.pbking.facebook.Facebook;
	import com.pbking.facebook.FacebookCall;
	import com.pbking.facebook.data.misc.FacebookEducationInfo;
	import com.pbking.facebook.data.misc.FacebookLocation;
	import com.pbking.facebook.data.misc.FacebookNetwork;
	import com.pbking.facebook.data.misc.FacebookWorkInfo;
	import com.pbking.facebook.data.users.FacebookUser;
	import com.pbking.facebook.data.util.FacebookDataParser;
	import com.pbking.facebook.delegates.FacebookDelegate;
	
	import flash.events.Event;

	public class GetUserInfo_delegate extends FacebookDelegate
	{
		public var users:Array;
		
		function GetUserInfo_delegate(users:Array, fields:Array)
		{
			this.users = users;
			var uids:Array = [];

			//put all of the users uids into an array to send
			for each(var user:FacebookUser in users)
				uids.push(user.uid);
			fbCall.setRequestArgument("format", "JSON");	
			fbCall.setRequestArgument("uids", uids.join(","));
			fbCall.setRequestArgument("fields", fields.join(","));
			fbCall.post("facebook.users.getInfo");
			
		}
		
		override protected function handleResult(result:Object):void
		{
			for each(var xUser:Object in result)
			{
				var modUser:FacebookUser = fBook.getUser(parseInt(xUser.uid));
				//populate the fields in the xUser data

				// NAME

				if(xUser.name)
					modUser.name = xUser.name.toString();

				if(xUser.first_name)
					modUser.first_name = xUser.first_name.toString();
					
				if(xUser.last_name)
					modUser.last_name = xUser.last_name.toString();
					
				// PICTURE
				
				if(xUser.pic_small)
					modUser.pic_small = xUser.pic_small.toString();

				if(xUser.pic_big)
					modUser.pic_big = xUser.pic_big.toString();

				if(xUser.pic_square)
					modUser.pic_square = xUser.pic_square.toString();

				if(xUser.pic)
					modUser.pic = xUser.pic.toString();

				// STATUS
				
				if(xUser.status_message)
					modUser.status_message = xUser.status.message.toString();

				if(xUser.status_time)
					modUser.status_time = FacebookDataParser.formatDate(xUser.status.time);
				
				// NETWORKS
				
				if(xUser.pic)
				{
					modUser.affiliations = [];
					for each ( var xNetwork:XML in xUser.affiliations ) 
					{
						var fbNetwork:FacebookNetwork = new FacebookNetwork();
						fbNetwork.nid = parseInt( xNetwork.nid );
						fbNetwork.name = xNetwork.name.toString();
						fbNetwork.type = xNetwork.type.toString();
						fbNetwork.status = xNetwork.status.toString();
						fbNetwork.year = xNetwork.year.toString();
		
						modUser.affiliations.push( fbNetwork );
					}
				}
				
				// HOMETOWN
				
				if(xUser.hometown_location)
				{
					modUser.hometown_location = new FacebookLocation();
					modUser.hometown_location.city = xUser.hometown_location.city.toString();
					modUser.hometown_location.state = xUser.hometown_location.state.toString();
					modUser.hometown_location.country = xUser.hometown_location.country.toString();
					modUser.hometown_location.zip = xUser.hometown_location.zip.toString();
				}
				
				// MISC DETAILS
				
				if(xUser.profile_update_time)
					modUser.profile_update_time = FacebookDataParser.formatDate( xUser.profile_update_time.toString() );

				if(xUser.timezone)
					modUser.timezone = parseInt( xUser.timezone );

				if(xUser.religion)
					modUser.religion = xUser.religion.toString();

				if(xUser.birthday)
					modUser.birthday = FacebookDataParser.formatDate(xUser.birthday.toString());

				if(xUser.sex)
					modUser.sex = xUser.sex.toString();
				
				if(xUser.political)
					modUser.political = xUser.political.toString();

				if(xUser.notes_count)
					modUser.notes_count = xUser.notes_count.toString();

				if(xUser.wall_count)
					modUser.wall_count = xUser.wall_count.toString();

				// RELATIONSHIP
				
				if(xUser.meeting_sex)
				{
					modUser.meeting_sex = [];
					for each ( var sex:XML in xUser.meeting_sex.sex )
						modUser.meeting_sex.push( sex.toString() )
				}
				
				if(xUser.meeting_sex)
				{
					modUser.meeting_for = [];
					for each ( var seeking:XML in xUser.meeting_for.seeking )
						modUser.meeting_for.push( seeking.toString() )
				}
				
				if(xUser.relationship_status)
					modUser.relationship_status = xUser.relationship_status.toString();

				if(xUser.significant_other_id)
					modUser.significant_other_id = parseInt( xUser.significant_other_id );
	
				// LOCATION
	
				if(xUser.hometown_location)
				{
					modUser.hometown_location = new FacebookLocation();
					modUser.hometown_location.city = xUser.hometown_location.city.toString();
					modUser.hometown_location.state = xUser.hometown_location.state.toString();
					modUser.hometown_location.country = xUser.hometown_location.country.toString();
					modUser.hometown_location.zip = xUser.hometown_location.zip.toString();
				}
	
				if(xUser.current_location)
				{
					modUser.current_location = new FacebookLocation();
					modUser.current_location.city = xUser.current_location.city.toString();
					modUser.current_location.state = xUser.current_location.state.toString();
					modUser.current_location.country = xUser.current_location.country.toString();
					modUser.current_location.zip = xUser.current_location.zip.toString();
				}
	
				// INTERESTS AND SUCH
	
				if(xUser.activities)
					modUser.activities = xUser.activities.toString();

				if(xUser.interests)
					modUser.interests = xUser.interests.toString();

				if(xUser.music)
					modUser.music = xUser.music.toString();

				if(xUser.tv)
					modUser.tv = xUser.tv.toString();

				if(xUser.movies)
					modUser.movies = xUser.movies.toString();

				if(xUser.books)
					modUser.books = xUser.books.toString();

				if(xUser.quotes)
					modUser.quotes = xUser.quotes.toString();

				if(xUser.about_me)
					modUser.about_me = xUser.about_me.toString();
				
				// EDUCATION
				
				if(xUser.hs1_name)
					modUser.hs1_name = xUser.hs_info.hs1_name.toString();

				if(xUser.hs2_name)
					modUser.hs2_name = xUser.hs_info.hs2_name.toString();

				if(xUser.grad_year)
					modUser.grad_year = xUser.hs_info.grad_year.toString();

				if(xUser.hs1_id)
					modUser.hs1_id = parseInt(xUser.hs_info.hs1_id);

				if(xUser.hs2_id)
					modUser.hs2_id = parseInt(xUser.hs_info.hs2_id);
				
				if(xUser.education_history)
				{
					modUser.education_history = [];
					for each ( var e:XML in xUser.education_history ) 
					{
						var educationInfo:FacebookEducationInfo = new FacebookEducationInfo();
						educationInfo.name = e.name.toString();
						educationInfo.year = e.year.toString();
						educationInfo.concentrations = [];

						for each ( var c:XML in e.concentration )
							educationInfo.concentrations.push( c.toString() )
		
						modUser.education_history.push( educationInfo );
					}
				}
				
				// WORK
	
				if(xUser.work_history)
				{
					modUser.work_history = [];
					
					for each ( var xWorkInfo:XML in xUser.work_history ) 
					{
						var workInfo:FacebookWorkInfo = new FacebookWorkInfo();
		
						workInfo.location = new FacebookLocation();
						workInfo.location.city = xWorkInfo.location.city.toString();
						workInfo.location.state = xWorkInfo.location.state.toString();
						workInfo.location.country = xWorkInfo.location.country.toString();
						workInfo.location.zip = xWorkInfo.location.zip.toString();
		
						workInfo.company_name = xWorkInfo.company_name.toString();
						workInfo.description = xWorkInfo.description.toString();
						workInfo.position = xWorkInfo.position.toString();
						workInfo.start_date = FacebookDataParser.formatDate(xWorkInfo.start_date.toString());
						workInfo.end_date = FacebookDataParser.formatDate( xWorkInfo.end_date.toString() );
		
						modUser.work_history.push( workInfo );
					}
				}
				
				// APPLICATION
				
				if(xUser.has_added_app)
					modUser.has_added_app = xUser.has_added_app == 1;
					
				if(xUser.is_app_user)
					modUser.is_app_user = xUser.is_app_user == 1;
			}
			
		}
		
	}
}