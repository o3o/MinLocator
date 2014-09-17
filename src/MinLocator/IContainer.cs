using System;

namespace Alexphi.MinLocator
{
    public interface IContainer
    {
        void Register<I, T>()
            where T : I, new();

        void Register<I>(Func<object> factory);

        I Resolve<I>();
    }
}
