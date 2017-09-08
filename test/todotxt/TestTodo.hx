package todotxt;

import haxe.Unserializer;
import haxe.Serializer;
import buddy.*;
using buddy.Should;

import todotxt.Todo;

class TestTodo extends BuddySuite {
	public function new() {
		describe('Using Todo', {
			it("should parse a list of tasks", {
                var list:String = "(A) Thank Mom for the meatballs @phone 
(B) Schedule Goodwill pickup +GarageSale @phone
Post signs around the neighborhood +GarageSale
@GroceryStore Eskimo pies";

                var todo:Todo = new Todo(list);
                
                todo.tasks.length.should.be(4);
                todo.tasks[0].description.should.be('Thank Mom for the meatballs @phone');
                todo.tasks[1].description.should.be('Schedule Goodwill pickup +GarageSale @phone');
                todo.tasks[2].description.should.be('Post signs around the neighborhood +GarageSale');
                todo.tasks[3].description.should.be('@GroceryStore Eskimo pies');
			});

            it('should compile a list of tasks back into a string', {
                var list:String = "(A) Thank Mom for the meatballs @phone
(B) Schedule Goodwill pickup +GarageSale @phone
Post signs around the neighborhood +GarageSale
@GroceryStore Eskimo pies";
                var todo:Todo = new Todo(list);
                var newList:String = todo.render();
                newList.should.be(list);
            });

			it('should serialize and unserialize back', {
                var list:String = "(A) Thank Mom for the meatballs @phone 
(B) Schedule Goodwill pickup +GarageSale @phone
Post signs around the neighborhood +GarageSale
@GroceryStore Eskimo pies";

                var todo:Todo = new Todo(list);

				var s:Dynamic = Serializer.run(todo);
				var u:Todo = Unserializer.run(s);

                todo.tasks.length.should.be(4);
                todo.tasks[0].description.should.be('Thank Mom for the meatballs @phone');
                todo.tasks[1].description.should.be('Schedule Goodwill pickup +GarageSale @phone');
                todo.tasks[2].description.should.be('Post signs around the neighborhood +GarageSale');
                todo.tasks[3].description.should.be('@GroceryStore Eskimo pies');
			});
		});
	}
}