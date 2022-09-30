import 'package:flutter/material.dart';

Widget errorContainer() {
  return Container(
    clipBehavior: Clip.hardEdge,
    child: Image.asset(
      'assets/img_not_available.jpeg',
      height: 200,
      width: 200,
    ),
  );
}

Widget chatImage({required String imageSrc, required Function onTap}) {
  return OutlinedButton(
    onPressed: onTap(),
    child: Image.network(
      imageSrc,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      loadingBuilder:
          (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 200,
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
              value: loadingProgress.expectedTotalBytes != null &&
                      loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, object, stackTrace) => errorContainer(),
    ),
  );
}

Widget messageBubble(
    {required String chatContent,
    required String replyContent,
    required EdgeInsetsGeometry? margin,
    Color? color,
    Color? textColor,
    bool isCurrentUser = true}) {
  return replyContent.isEmpty
      ? Container(
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
          padding: const EdgeInsets.all(10),
          margin: margin,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            chatContent,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        )
      : ConstrainedBox(
          constraints: const BoxConstraints(
              maxHeight: 100, minHeight: 65, maxWidth: 200),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: margin,
                height: 50,
                constraints: const BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  replyContent,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              isCurrentUser
                  ? Positioned(
                      top: 30,
                      right: 0,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.all(5),
                        margin: margin,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          chatContent,
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ),
                    )
                  : Positioned(
                      top: 30,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: margin,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          chatContent,
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ),
                    ),
            ],
          ),
        );
}
