import React, { createContext, useContext } from 'react'

const ApplicationContext = createContext({ currentUser: null })

const ApplicationProvider = ({ children }) => {
  const currentUser =
    JSON.parse(document.getElementById('data').dataset['currentUser'])

  return (
    <ApplicationContext.Provider value={{ currentUser }}>
      {children}
    </ApplicationContext.Provider>
  )
}

export const useApplicationProvider = () => useContext(ApplicationContext)

export default ApplicationProvider
