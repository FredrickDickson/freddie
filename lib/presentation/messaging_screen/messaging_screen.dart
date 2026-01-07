import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/conversation_list_item_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/property_context_card_widget.dart';
import './widgets/typing_indicator_widget.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({Key? key}) : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isConversationView = false;
  bool _isTyping = false;
  bool _showTypingIndicator = false;
  Map<String, dynamic>? _selectedConversation;

  final List<Map<String, dynamic>> _conversations = [
    {
      "id": 1,
      "contactName": "Adebayo Johnson",
      "propertyTitle": "3 Bedroom Flat in Lekki Phase 1",
      "propertyImage":
          "https://images.unsplash.com/photo-1721395286594-8913b06056eb",
      "propertyImageLabel":
          "Modern three-bedroom apartment with white walls and large windows in Lekki Phase 1",
      "lastMessage":
          "Yes, the property is still available. When would you like to schedule a viewing?",
      "timestamp": "2 min ago",
      "unreadCount": 2,
    },
    {
      "id": 2,
      "contactName": "Chioma Okafor",
      "propertyTitle": "2 Bedroom Apartment in Victoria Island",
      "propertyImage":
          "https://images.unsplash.com/photo-1723828226117-5525761f623e",
      "propertyImageLabel":
          "Luxury two-bedroom apartment with modern kitchen and ocean view in Victoria Island",
      "lastMessage":
          "Thank you for your interest. The rent is ₦2.5M per annum.",
      "timestamp": "1 hour ago",
      "unreadCount": 0,
    },
    {
      "id": 3,
      "contactName": "Emeka Nwankwo",
      "propertyTitle": "4 Bedroom Duplex in Ikeja GRA",
      "propertyImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_163baecef-1767786169758.png",
      "propertyImageLabel":
          "Spacious four-bedroom duplex with garden and parking space in Ikeja GRA",
      "lastMessage":
          "I can show you the property tomorrow at 3 PM if that works for you.",
      "timestamp": "Yesterday",
      "unreadCount": 1,
    },
    {
      "id": 4,
      "contactName": "Fatima Abdullahi",
      "propertyTitle": "Studio Apartment in Yaba",
      "propertyImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_132626547-1766145574497.png",
      "propertyImageLabel":
          "Compact studio apartment with modern furnishings and kitchenette in Yaba",
      "lastMessage":
          "The apartment comes fully furnished with AC and generator backup.",
      "timestamp": "2 days ago",
      "unreadCount": 0,
    },
    {
      "id": 5,
      "contactName": "Oluwaseun Adeyemi",
      "propertyTitle": "5 Bedroom House in Ikoyi",
      "propertyImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1eeae60b5-1767786167710.png",
      "propertyImageLabel":
          "Luxury five-bedroom house with swimming pool and security in Ikoyi",
      "lastMessage":
          "This property is perfect for families. Would you like to see more photos?",
      "timestamp": "3 days ago",
      "unreadCount": 0,
    },
  ];

  List<Map<String, dynamic>> _filteredConversations = [];

  final List<Map<String, dynamic>> _messages = [
    {
      "id": 1,
      "content":
          "Hello, I'm interested in viewing this property. Is it still available?",
      "timestamp": "10:30 AM",
      "isSender": true,
      "status": "read",
    },
    {
      "id": 2,
      "content":
          "Good morning! Yes, the property is still available. When would you like to schedule a viewing?",
      "timestamp": "10:32 AM",
      "isSender": false,
      "status": "delivered",
    },
    {
      "id": 3,
      "content": "Great! How about tomorrow afternoon around 3 PM?",
      "timestamp": "10:35 AM",
      "isSender": true,
      "status": "read",
    },
    {
      "id": 4,
      "content":
          "That works perfectly. I'll send you the exact address and meeting point.",
      "timestamp": "10:36 AM",
      "isSender": false,
      "status": "delivered",
    },
    {
      "id": 5,
      "content": "Here are some additional photos of the property interior.",
      "timestamp": "10:37 AM",
      "isSender": false,
      "status": "delivered",
      "attachmentUrl":
          "https://images.unsplash.com/photo-1704040686428-7534b262d0d8",
      "attachmentType": "image",
      "attachmentLabel":
          "Interior photo showing spacious living room with modern furniture and large windows",
    },
    {
      "id": 6,
      "content":
          "Thank you! The interior looks amazing. Can you also share the tenancy agreement template?",
      "timestamp": "10:40 AM",
      "isSender": true,
      "status": "read",
    },
    {
      "id": 7,
      "content":
          "Absolutely! I'll attach the standard tenancy agreement document.",
      "timestamp": "10:42 AM",
      "isSender": false,
      "status": "delivered",
      "attachmentUrl": "https://example.com/tenancy-agreement.pdf",
      "attachmentType": "document",
      "attachmentLabel": "Standard tenancy agreement document",
    },
  ];

  final Map<String, dynamic> _propertyContext = {
    "title": "3 Bedroom Flat in Lekki Phase 1",
    "location": "Lekki Phase 1, Lagos",
    "price": "₦3,500,000/year",
    "type": "For Rent",
    "image":
        "https://images.unsplash.com/photo-1721395286594-8913b06056eb",
    "imageLabel":
        "Modern three-bedroom apartment with white walls and large windows in Lekki Phase 1",
  };

  final List<String> _messageTemplates = [
    "Hello, I'm interested in this property. Is it still available?",
    "Can we schedule a viewing for this property?",
    "What are the payment terms for this property?",
    "Does the property come furnished?",
    "Are pets allowed in this property?",
  ];

  @override
  void initState() {
    super.initState();
    _filteredConversations = List.from(_conversations);
    _searchController.addListener(_filterConversations);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterConversations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredConversations = query.isEmpty
          ? List.from(_conversations)
          : (_conversations as List)
                .where((conv) {
                  final propertyTitle = (conv['propertyTitle'] as String? ?? '')
                      .toLowerCase();
                  final contactName = (conv['contactName'] as String? ?? '')
                      .toLowerCase();
                  return propertyTitle.contains(query) ||
                      contactName.contains(query);
                })
                .cast<Map<String, dynamic>>()
                .toList();
    });
  }

  void _openConversation(Map<String, dynamic> conversation) {
    setState(() {
      _selectedConversation = conversation;
      _isConversationView = true;
      conversation['unreadCount'] = 0;
    });
    _scrollToBottom();
  }

  void _closeConversation() {
    setState(() {
      _isConversationView = false;
      _selectedConversation = null;
      _showTypingIndicator = false;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "id": _messages.length + 1,
        "content": _messageController.text.trim(),
        "timestamp": _formatCurrentTime(),
        "isSender": true,
        "status": "sent",
      });
      _messageController.clear();
      _isTyping = false;
      _showTypingIndicator = true;
    });

    _scrollToBottom();

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showTypingIndicator = false;
          _messages.add({
            "id": _messages.length + 1,
            "content":
                "Thank you for your message. I'll get back to you shortly.",
            "timestamp": _formatCurrentTime(),
            "isSender": false,
            "status": "delivered",
          });
        });
        _scrollToBottom();
      }
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
  }

  void _showAttachmentOptions() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                size: 24,
                color: theme.colorScheme.primary,
              ),
              title: Text('Take Photo', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(sheetContext);
                _capturePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                size: 24,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                'Choose from Gallery',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'description',
                size: 24,
                color: theme.colorScheme.primary,
              ),
              title: Text('Attach Document', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickDocument();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _messages.add({
            "id": _messages.length + 1,
            "content": "",
            "timestamp": _formatCurrentTime(),
            "isSender": true,
            "status": "sent",
            "attachmentUrl": photo.path,
            "attachmentType": "image",
            "attachmentLabel": "Photo captured from camera",
          });
        });
        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture photo'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _messages.add({
            "id": _messages.length + 1,
            "content": "",
            "timestamp": _formatCurrentTime(),
            "isSender": true,
            "status": "sent",
            "attachmentUrl": image.path,
            "attachmentType": "image",
            "attachmentLabel": "Photo selected from gallery",
          });
        });
        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select image'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _messages.add({
            "id": _messages.length + 1,
            "content": "",
            "timestamp": _formatCurrentTime(),
            "isSender": true,
            "status": "sent",
            "attachmentUrl": file.path ?? file.name,
            "attachmentType": "document",
            "attachmentLabel": "Document: ${file.name}",
          });
        });
        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select document'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showMessageTemplates() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Text(
                'Quick Message Templates',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(),
            ..._messageTemplates.map(
              (template) => ListTile(
                title: Text(template, style: theme.textTheme.bodyMedium),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _messageController.text = template;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _archiveConversation(Map<String, dynamic> conversation) {
    setState(() {
      _conversations.remove(conversation);
      _filteredConversations.remove(conversation);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation archived'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _conversations.add(conversation);
              _filterConversations();
            });
          },
        ),
      ),
    );
  }

  void _deleteConversation(Map<String, dynamic> conversation) {
    setState(() {
      _conversations.remove(conversation);
      _filteredConversations.remove(conversation);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _isConversationView
        ? _buildChatView(theme)
        : _buildConversationList(theme);
  }

  Widget _buildConversationList(ThemeData theme) {
    return Column(
      children: [
        CustomAppBar(
          title: 'Messages',
          actions: [
            IconButton(
              onPressed: _showMessageTemplates,
              icon: CustomIconWidget(
                iconName: 'chat_bubble_outline',
                size: 24,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  size: 24,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _filterConversations();
                      },
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: _filteredConversations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'chat_bubble_outline',
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _searchController.text.isEmpty
                            ? 'No conversations yet'
                            : 'No conversations found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Start chatting with property owners'
                            : 'Try a different search term',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredConversations.length,
                  itemBuilder: (context, index) {
                    final conversation = _filteredConversations[index];
                    return ConversationListItemWidget(
                      conversation: conversation,
                      onTap: () => _openConversation(conversation),
                      onArchive: () => _archiveConversation(conversation),
                      onDelete: () => _deleteConversation(conversation),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildChatView(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _closeConversation,
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
            color: theme.colorScheme.onSurface,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedConversation?['contactName'] as String? ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _selectedConversation?['propertyTitle'] as String? ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/property-details-screen');
            },
            icon: CustomIconWidget(
              iconName: 'info_outline',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _messages.length + (_showTypingIndicator ? 2 : 1),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PropertyContextCardWidget(
                    property: _propertyContext,
                    onViewDetails: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed('/property-details-screen');
                    },
                    onScheduleViewing: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Opening calendar for viewing schedule...',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                }

                if (_showTypingIndicator && index == _messages.length + 1) {
                  return TypingIndicatorWidget(
                    userName:
                        _selectedConversation?['contactName'] as String? ?? '',
                  );
                }

                final messageIndex = index - 1;
                final message = _messages[messageIndex];
                return MessageBubbleWidget(
                  message: message,
                  isSender: message['isSender'] as bool? ?? false,
                  onLongPress: () {
                    setState(() {
                      _messages.removeAt(messageIndex);
                    });
                  },
                );
              },
            ),
          ),
          MessageInputWidget(
            controller: _messageController,
            onSend: _sendMessage,
            onAttachment: _showAttachmentOptions,
            onTypingChanged: (isTyping) {
              setState(() => _isTyping = isTyping);
            },
          ),
        ],
      ),
    );
  }
}
