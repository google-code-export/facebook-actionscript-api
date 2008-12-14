package com.pbking.facebook
{
	/**
	 * DEPRECIATED
	 * 
	 * Adds support for the depreciated Facebook Delegates
	 */
	 
	public class FacebookWithDelegates extends Facebook
	{
		// CONSTRUCTION //////////
		
		public function FacebookWithDelegates()
		{
			super();
		}
		
		// METHOD GROUPS //////////
		
		protected var _photos:Photos;
		public function get photos():Photos 
		{ 
			if(!_photos)
				_photos = new Photos(this)
			return this._photos; 
		}
		
		protected var _friends:Friends;
		public function get friends():Friends 
		{ 
			if(!_friends)
				_friends = new Friends(this)
			return this._friends; 
		}
		
		protected var _users:Users;
		public function get users():Users 
		{ 
			if(!_users)
				_users = new Users(this)
			return this._users; 
		}
		
		protected var _events:Events;
		public function get events():Events 
		{ 
			if(!_events)
				_events = new Events(this)
			return this._events; 
		}
		
		protected var _feed:Feed;
		public function get feed():Feed 
		{ 
			if(!_feed)
				_feed = new Feed(this)
			return this._feed; 
		}
		
		protected var _fql:Fql;
		public function get fql():Fql 
		{ 
			if(!_fql)
				_fql = new Fql(this)
			return this._fql; 
		}
		
		protected var _groups:Groups;
		public function get groups():Groups 
		{ 
			if(!_groups)
				_groups = new Groups(this)
			return this._groups; 
		}
		
		protected var _marketplace:Marketplace;
		public function get marketplace():Marketplace 
		{ 
			if(!_marketplace)
				_marketplace = new Marketplace(this)
			return this._marketplace; 
		}
		
		protected var _notifications:Notifications;
		public function get notifications():Notifications 
		{ 
			if(!_notifications)
				_notifications = new Notifications(this)
			return this._notifications; 
		}
		
		protected var _pages:Pages;
		public function get pages():Pages 
		{ 
			if(!_pages)
				_pages = new Pages(this)
			return this._pages; 
		}
		
		protected var _profile:Profile;
		public function get profile():Profile 
		{ 
			if(!_profile)
				_profile = new Profile(this)
			return this._profile; 
		}
		
	}
}