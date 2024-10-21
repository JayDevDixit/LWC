public class WhatsAppMessage{
	public entry[] entry;
	public class entry {
		public String id;	//483521461504147
		public changes[] changes;
	 }
	public class changes {
		public value value;
		public String field;	//messages
	}
	public class value {
		public String messaging_product;	//whatsapp
		public metadata metadata;
		public contacts[] contacts;
		public messages[] messages;
	}
	public class metadata {
		public String display_phone_number;	//15551800291
		public String phone_number_id;	//490966720759591
	}
	public class contacts {
		public profile profile;
		public String wa_id;	//917599001744
	}
	public class profile {
		public String name;	//J D
	}
	public class messages {
		public String fromx;	//917599001744
		public String id;	//wamid.HBgMOTE3NTk5MDAxNzQ0FQIAEhgUM0ZGQUFCMTkzMDI3OTY1RTUxMzUA
		public String timestamp;	//1729167232
		public text text;
		public String typex;	//text
	}
	public class text {
		public String body;	//Mike Tysoon
	}
	
}