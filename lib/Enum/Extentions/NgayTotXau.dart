import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/emojione_v1.dart';
class Item {
	String? title;
	Widget? icon;
	var payload;
	Item(this.title,this.icon,this.payload);
}

class NgayTotXau{
	static List<Item> item =[
		new Item('engagementday'.tr, Iconify(EmojioneV1.man_and_woman_holding_hands,size: 28,),{
			'title': 'engagementday'.tr,
			"des":"Dạm ngõ là một lễ nghi theo phong tục cưới hỏi của người Việt Nam, dạm ngõ (chạm ngõ, xem mặt...) là buối gặp gỡ giữa nhà trai và nhà gái nhằm chính thức hóa việc tìm hiểu cho đôi nam nữ, cũng là dịp để hai gia đình bàn bạc, thống nhất việc tổ chức cưới hỏi. Theo phong tục cổ truyền, nhà trai thường đem đến một cơi trầu, chè, bánh v.v.",
			"key":13
		}),
		new Item("engagementceremony".tr, Iconify(EmojioneV1.ring,size: 28),{
			'title': "engagementceremony".tr,
			'des':"Lễ ăn hỏi hay còn gọi là lễ đính hôn, là một nghi lễ quan trọng trong phong tục cưới hỏi của người Việt Nam, vì thế hai bên gia đình phải thống nhất chọn được ngày giờ đẹp mới tiến hành lễ ăn hỏi. Vào đúng ngày giờ đã chọn nhà trai sẽ cho các chàng trai bê các tráp dẫn lễ tới nhà gái. Lễ vật trong ngày này không thể thiếu trầu cau, rượu bia, bánh kẹo, tiền, vàng v.v.",
			"key":14
		}),
		new Item("weddingday".tr, Iconify(EmojioneV1.revolving_hearts,size: 28),{
			'title': "weddingday".tr,
			'des':'Ca dao có câu: "Tậu trâu, cưới vợ làm nhà \-Trong ba việc ấy thật là khó thay\". Cưới xin là công việc trọng đại của cuộc đời con người nên việc chọn thời gian tổ chức đám cưới là việc cần được hai gia đình bàn bạc đi đến thống nhất. Lễ cưới là nghi thức công nhận đôi uyên ương chính thức trở thành vợ chồng, thường thông qua các thủ tục xin dâu, rước dâu, thành hôn.',
			"key": 25
		}),
		new Item("demolishbreak".tr, Iconify(EmojioneV1.wrench,size: 28),{
			'title': "demolishbreak".tr,
			"key": 36
		}),
		new Item("housedemolition".tr, Iconify(EmojioneV1.hammer_and_wrench,size: 28),{
			'title': "housedemolition".tr,
			"des":"Người ta thường tin rằng mỗi công trình xây dựng gắn liền với đất đai đều có thần linh cai quản, cho dù xây dựng hay phá dỡ, đều động chạm tới sự thanh tịnh của thần linh sở ngự. Do đó, để công việc phá dỡ được an toàn, thuận lợi mọi người thường chọn ngày giờ thích hợp để tiếp hành tháo dỡ, hủy bỏ tránh phạm tới phong thủy địa mạch.",
			"key": 29
		}),
		new Item("warehouserepair".tr, Iconify(EmojioneV1.i_factory,size: 28),{
			'title': "warehouserepair".tr,
			'des':'Nhà kho là nơi chứa hàng hóa, nhu yếu phẩm trong đời sống sinh hoạt cũng như hoạt động kinh doanh của cá nhân, doanh nghiệp... Chọn thời điểm phù hợp để tu sửa nhà kho rất cần thiết, hợp với tín ngưỡng và hy vọng sự hanh thông, may mắn, an lành cho người chủ.',
			"key": 35
		}),
		new Item("renovationandrepair".tr, Iconify(EmojioneV1.scissors,size: 28),{
			'title': "renovationandrepair".tr,
			"key":10
		}),
		new Item("Diggingawell".tr, Iconify(EmojioneV1.bomb,size: 28),{
			'title': "Diggingawell".tr,
			"des":"Giếng nước, ao làng là hình ảnh vô cùng thân thuộc gắn bó với đời sống của người Việt từ xưa, không chỉ là nơi cung cấp nước phục vụ cho sinh hoạt mà nó còn tạo cảnh quan môi trường sống cho con người. Để tránh động long mạnh, người ta luôn có ý thức chọn ngày lành rồi mới tiến hành đào, vét.",
			"key":41
		}),
		new Item("Grandopening".tr, Iconify(EmojioneV1.office_building,size: 28),{
			'title': "Grandopening".tr,
			"des":"Khai trương là việc bắt đầu cho các hoạt động sản xuất, kinh doanh. Người Việt Nam có quan niệm \"đầu xuôi đuôi lọt\" vì thế thường chọn ngày lành tháng tốt, sửa soạn chu đáo những lễ vậ để cúng tế với mong muốn việc kinh doanh được thuận lợi, hanh thông.",
			"key":4
		}),
		new Item("Contracting".tr, Iconify(EmojioneV1.memo,size: 28),{
			'title': "Contracting".tr,
			"des":"Hợp đồng là thỏa thuận thường thấy trong các giao dịch xã hội. Việc ký kết hợp đồng thể hiện sự thống nhất hợp tác giữa hai hay nhiều bên nhằm thực hiện công việc nhất định. Để việc hợp tác suôn sẻ, công việc được thông suốt người ta thường chọn thời điểm cát lợi, tránh dịp hung hại để tăng vượng khí.",
			"key":28
		}),
		new Item("exportgoods".tr, Iconify(EmojioneV1.card_file_box,size: 28),{
			'title': "exportgoods".tr,
			"des":"Nhập xuất hàng hóa là một trong những khâu quan trọng trong sản xuất kinh doanh, ảnh hưởng trực tiếp đến sự vận hành xuyên suốt của hoạt động thương mại. Chính bởi lẽ đó, người chủ các đơn vị kinh doanh thường lựa chọn thời điểm thuận lợi để tiến hành việc xuất nhập hàng hóa với mong muốn gặp thuận lợi tránh được những xui rủi trong chuyện làm ăn.",
			"key":19
		}),
		new Item("depart".tr, Iconify(EmojioneV1.airplane_arrival,size: 28),{
			'title': "depart".tr,
			"des":"Xuất hành là một công việc luôn được người Việt chú ý và coi trọng. Với hy vọng khởi đầu thuận lợi, bình an, ta luôn có ý thức chọn ngày lành, giờ hoàng đạo để bắt đầu công việc. Đặc biệt khi tiến hành làm những việc quan trọng, có tính chất chuyển ngoặt như xuất ngoại, xuất hành năm mới, hành hương thậm chí đi công tác, về quê, du lịch.",
			"key":2
		}),
		new Item("Blessing".tr, Iconify(EmojioneV1.family_man_woman_girl_boy,size: 28),{
			'title': "Blessing".tr,
			"des":"Cầu phúc lành là một sinh hoạt tín ngưỡng dân gian của người Việt Nam. Đây là hoạt động không chỉ thể hiện sự kính ngưỡng với Trời Đất, Thần Phật mà còn nói lên ước muốn có một cuộc sống thái bình, ấm no, hạnh phúc cho mọi người trọng gia đình, rộng hơn là cho cả đất nước.",
			"key":31
		}),
		new Item("Pray".tr, Iconify(EmojioneV1.carp_streamer,size: 28),{
			'title': "Pray".tr,
			"des":"Cầu cúng là tín ngưỡng phổ biến của người phương Đông nói chung và người Việt Nam nói riêng. Khóa lễ cầu cúng được thực hiện khi gia chủ mong muôn nhận được sự che chở, phù hộ của Phật, thần linh, gia tiên dòng họ... cho cuộc sống thường hằng của họ được bình an.",
			"key":11
		}),
		new Item("Prayyourself".tr, Iconify(EmojioneV1.baby_angel,size: 28),{
			'title': "Prayyourself".tr,
			"des":"Con cái là món quà quý mà tạo hóa ban tặng cho cha mẹ. Có những cặp vợ chồng vì lý do nào đó lấy nhau đã lâu mà vẫn chưa có con, họ thường chọn ngày lành tháng tốt đi đến \"cửa đền cửa chùa\" dâng lễ để xin có con. Cầu tự là một hình thức tâm linh, cầu khấn thần linh hay tín ngưỡng phồn thực để mong cầu sinh con.",
			"key":21
		}),
		new Item("Admission".tr, Iconify(EmojioneV1.school,size: 28),{
			'title': "Admission".tr,
			"key":12
		}),
		new Item("Receivetitle".tr, Iconify(EmojioneV1.trophy,size: 28),{
			'title': "Receivetitle".tr,
			"key":23
		}),
		new Item("Buycattle".tr, Iconify(EmojioneV1.pig,size: 28),{
			'title': "Buycattle".tr,
			"key":38
		}),

	];
}
