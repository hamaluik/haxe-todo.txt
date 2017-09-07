package ;

import todotxt.*;

class TestMain {
	public static function main() {
		var reporter = new buddy.reporting.ConsoleFileReporter(true);
		var runner = new buddy.SuitesRunner([
			new TestTask(),
			new TestTodo()
		], reporter);

		runner.run();
	}
}