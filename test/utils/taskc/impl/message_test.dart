import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskc/impl/message.dart';

void main() {
  group('TaskserverResponseException', () {
    test('should create TaskserverResponseException with header', () {
      final header = {
        'type': 'error',
        'code': '404',
      };
      final exception = TaskserverResponseException(header);
      expect(exception.header, header);
    });

    test(
        'should return formatted string representation of TaskserverResponseException',
        () {
      final header = {
        'type': 'error',
        'code': '404',
      };
      final exception = TaskserverResponseException(header);
      const expectedString = 'response.header = {\n'
          '  "type": "error",\n'
          '  "code": "404"\n'
          '}';
      expect(exception.toString(), expectedString);
    });
  });

  group('EmptyResponseException', () {
    test(
        'should return formatted string representation of EmptyResponseException',
        () {
      final exception = EmptyResponseException();
      const expectedString = 'The server returned an empty response. '
          'Please review the server logs or contact administrator.\n'
          '\n'
          'This may be an issue with the triple:\n'
          '- taskd.certificate\n'
          '- taskd.key\n'
          '- \$TASKDDATA/ca.cert.pem';
      expect(exception.toString(), expectedString);
    });
  });
}
