using System;
using System.Collections.Generic;

namespace Alexphi.MinLocator
{
    public class Container : IContainer
    {
        readonly Dictionary<Type, Func<object>> _services = new Dictionary<Type, Func<object>>();

        public void Register<I, T>()
            where T : I, new()
        {
            _services.Add(typeof(I), () => new T());
        }

        public void Register<I>(Func<object> factory)
        {
            _services.Add(typeof(I), factory);
        }

        public I Resolve<I>()
        {
            if (_services.ContainsKey(typeof(I)))
                return (I)_services[typeof(I)]();
            else
                throw new KeyNotFoundException();
        }
    }
}
