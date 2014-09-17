using PetaTest;
namespace MinLocator.Test {
   [TestFixture]
   public class ServiceLocatorTest {
      [Test]public void Locator_should_accept_two_interfaces() {
         var container = new Container();
         Foo fooConcrete = new Foo();
         container.Register<Foo>(() => fooConcrete);

         IFoo fooInterface = new Foo();
         container.Register<IFoo>(() => fooInterface);
         Locator.SetContainer(container);

         var locator = Locator.Current;
         Assert.AreSame(locator.Get<IFoo>(), fooInterface);
         Assert.AreNotSame(locator.Get<IFoo>(), fooConcrete);

         Assert.AreSame(locator.Get<Foo>(), fooConcrete);
         Assert.AreNotSame(locator.Get<Foo>(), fooInterface);
         Assert.Throws<System.Collections.Generic.KeyNotFoundException>(() => locator.Get<IBar>());
      }

      [Test]
      public void Add_same_interface_should_throw_an_error() {
         var container = new Container();
         container.Register<Foo>(() => new Foo());
         Assert.Throws<System.ArgumentException>(() => container.Register<Foo>( () => new Foo()));
      }
      [Test]
      public void Add_same_interface_should_throw_an_error() {
         var container = new Container();
         container.Register<Foo>(() => new Foo("a"));

         Assert.Throws<System.ArgumentException>(() => container.Register<Foo>( () => new Foo()));
      }
   }

   public interface IFoo {
      string Foon {get; set;}
   }

   public class Foo: IFoo {
      public Foo() {
         this.Foon = "f";
      }

      public Foo(string s) {
         this.Foon = s;
      }

      public string Foon {get; set;}
   }

   public interface IBar {
      string Barn {get;}
   }

   public class Bar: IBar {
      private readonly foo;
      public Bar(IFoo foo) {
         this.foo = foo;

      }
      public string Barn {
         get { return foo.Foon + ": bar"}
      }
   }

}
