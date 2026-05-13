import 'package:chopper/chopper.dart';

// Chopper сам напишет этот файл для нас
part 'api_service.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService {
  
  // Делаем GET-запрос по этому адресу, чтобы получить список товаров
  @Get(path: '/products')
  Future<Response> getProducts();

  static ApiService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://fakestoreapi.com'),
      services: [
        _$ApiService(),
      ],
      // Эта штука автоматически превращает ответ сервера в удобный формат
      converter: const JsonConverter(),
    );
    return _$ApiService(client);
  }
}