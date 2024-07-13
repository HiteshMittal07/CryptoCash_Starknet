import { Routes, Route } from "react-router-dom";
import CreateNote from "../components/createNote";
const Router = () => {
  return (
    <Routes>
      <Route path="/create" element={<CreateNote />} />
    </Routes>
  );
};
export default Router;
