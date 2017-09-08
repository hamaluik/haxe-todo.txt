package todotxt;

import haxe.Serializer;
import haxe.Unserializer;

import buddy.*;
using buddy.Should;

import todotxt.Task;

class TestTask extends BuddySuite {
	public function new() {
		describe('Using Tasks', {
			it("should parse the simplest task", {
				var task:Task = new Task('Call the doctor');
				task.completed.should.be(false);
				task.description.should.be('Call the doctor');
			});

			it('should detect completed tasks', {
				var task:Task = new Task('x Call the doctor');
				task.completed.should.be(true);
				task.description.should.be('Call the doctor');
			});

			it('should parse the priority', {
				var taskA:Task = new Task('(A) Call the doctor');
				var taskB:Task = new Task('(B) Thank Mom for the meatballs');

				taskA.priority.should.be('A');
				taskA.description.should.be('Call the doctor');

				taskB.priority.should.be('B');
				taskB.description.should.be('Thank Mom for the meatballs');
			});

			it('should reject malformed priorities', {
				var taskA:Task = new Task('Really gotta call Mom (A) @phone @someday');
				taskA.priority.should.be(null);
				taskA.description.should.be('Really gotta call Mom (A) @phone @someday');

				var taskB:Task = new Task('(b) get back to the boss');
				taskB.priority.should.be(null);
				taskB.description.should.be('(b) get back to the boss');

				var taskC:Task = new Task('(C)->Submit TPS report');
				taskC.priority.should.be(null);
				taskC.description.should.be('(C)->Submit TPS report');
			});

			it('should parse creation date', {
				var taskA:Task = new Task('2011-03-02 Document +TodoTxt task format');
				taskA.startedOn.toString().should.be('2011-03-02 00:00:00');

				var taskB:Task = new Task('(A) 2011-03-02 Call Mom');
				taskB.startedOn.toString().should.be('2011-03-02 00:00:00');
			});

			it('should parse creation and completion dates', {
				var taskA:Task = new Task('x 2011-03-02 2011-03-01 Review Tim\'s pull request +TodoTxtTouch @github');
				taskA.completedOn.toString().should.be('2011-03-02 00:00:00');
				taskA.startedOn.toString().should.be('2011-03-01 00:00:00');
			});

			it('should identify projects', {
				var taskA:Task = new Task('(A) Call Mom +Family +PeaceLoveAndHappiness @iphone @phone');

				taskA.description.should.be('Call Mom +Family +PeaceLoveAndHappiness @iphone @phone');
				taskA.projects.length.should.be(2);
				taskA.projects[0].should.be('Family');
				taskA.projects[1].should.be('PeaceLoveAndHappiness');
			});
			
			it('should identify contexts', {
				var taskA:Task = new Task('(A) Call Mom +Family +PeaceLoveAndHappiness @iphone @phone');

				taskA.description.should.be('Call Mom +Family +PeaceLoveAndHappiness @iphone @phone');
				taskA.contexts.length.should.be(2);
				taskA.contexts[0].should.be('iphone');
				taskA.contexts[1].should.be('phone');
			});

			it('should render back properly', {
				var taskA:Task = new Task('x 2011-03-02 2011-03-01 Review Tim\'s pull request +TodoTxtTouch @github');
				taskA.render().should.be('x 2011-03-02 2011-03-01 Review Tim\'s pull request +TodoTxtTouch @github');

				var taskB:Task = new Task('(A) Call Mom +Family +PeaceLoveAndHappiness @iphone @phone');
				taskB.render().should.be('(A) Call Mom +Family +PeaceLoveAndHappiness @iphone @phone');
			});

			it('should serialize and unserialize back', {
				var taskA:Task = new Task('x 2011-03-02 2011-03-01 Review Tim\'s pull request +TodoTxtTouch @github');

				var s:Dynamic = Serializer.run(taskA);
				var u:Task = Unserializer.run(s);

				u.completed.should.be(true);
				u.completedOn.toString().should.be('2011-03-02 00:00:00');
				u.startedOn.toString().should.be('2011-03-01 00:00:00');
				u.description.should.be('Review Tim\'s pull request +TodoTxtTouch @github');
			});
		});
	}
}