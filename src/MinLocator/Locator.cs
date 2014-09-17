using System;

namespace Alexphi.MinLocator
{
    public class Locator : ILocator
    {
        public static ILocator Current { get; private set; }

        // Sets the current container
        public static void SetContainer(IContainer container)
        {
            Current = new Locator(container);
        }

        IContainer _container;

        // Constructor
        protected Locator(IContainer container)
        {
            this._container = container;
        }

        public I Get<I>()
        {
            return (I)this._container.Resolve<I>();
        }
    }
}
