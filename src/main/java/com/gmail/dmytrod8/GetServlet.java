package com.gmail.dmytrod8;

import com.google.gson.Gson;
import com.google.gson.JsonElement;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(
        name = "GetServlet",
        urlPatterns = {"/get"}
)
public class GetServlet extends HttpServlet {

    static EntityManagerFactory emf;
    static EntityManager em;
    private ServerResponse srvResp = ServerResponse.getInstance();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");

        final String name = req.getParameter("name");
        final String phone = req.getParameter("phone");
        final String email = req.getParameter("email");

        if (name == null || phone == null || email == null) {
            getAllUsers(resp);
        } else if (name.equals("") || phone.equals("") || email.equals("")) {
            return;
        } else {
            addUser(name, phone, email, resp);
        }
    }

    private void addUser(String name, String phone, String email, HttpServletResponse resp) {
        try {
            emf = Persistence.createEntityManagerFactory("JPATest");
            em = emf.createEntityManager();
            try {
                em.getTransaction().begin();
                try {
                    User c = new User(name, phone, email);
                    em.persist(c);
                    em.getTransaction().commit();
                } catch (Exception ex) {
                    ex.printStackTrace();
                    em.getTransaction().rollback();
                }
                getAllUsers(resp);
            } finally {
                em.close();
                emf.close();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return;
        }
    }

    private void getAllUsers(HttpServletResponse resp) throws IOException {
        try {
            emf = Persistence.createEntityManagerFactory("JPATest");
            em = emf.createEntityManager();

            try {
                Query query = em.createQuery("SELECT c FROM User c", User.class);
                List<User> usersList = (List<User>) query.getResultList();
                if (usersList.size() > 0) {
                    final JsonElement jelement = toJSON((ArrayList<User>) usersList);
                    srvResp.sendResponse(resp, 0, jelement);
                } else {
                    srvResp.sendResponse(resp, "response:2");
                }
            } finally {
                em.close();
                emf.close();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return;
        }
    }

    private JsonElement toJSON(ArrayList<User> usersList) {
        return (JsonElement) new Gson().toJsonTree(new JsonUsers(usersList));

    }
}
