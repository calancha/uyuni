import { useState, useCallback } from 'react';

export function useInputValue(initialValue) {
  const [value, setValue] = useState(initialValue);
  const onChange = useCallback((event) => setValue(event.currentTarget.value), []);

  return {
    value,
    onChange,
  };
}
