/*import { shallowMount, createLocalVue } from "@vue/test-utils";
import Vuex from "vuex";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
import AddBus from "@/components/AddBus.vue";

const localVue = createLocalVue();
localVue.use(Vuex);

describe("AddBus.vue", () => {
    let mock;
    let store;
    let actions;

    beforeEach(() => {
        // إعداد Mock للطلبات
        mock = new MockAdapter(axios);

        // إعداد Vuex store
        actions = {
            // أضف أي إجراءات Vuex تحتاجها
        };
        store = new Vuex.Store({
            state: {
                Bus: [],
            },
            actions,
        });
    });

    afterEach(() => {
        mock.reset();
    });

    it("should submit the form successfully", async () => {
        mock.onPost("http://127.0.0.1:8000/api/company/store_bus").reply(200, {
            success: true,
        });

        const wrapper = shallowMount(AddBus, { localVue, store });

        // إعداد البيانات
        await wrapper.setData({
            number_bus: "123",
            number_passenger: "45",
        });

        // تقديم النموذج
        await wrapper.find("form").trigger("submit.prevent");

        // التحقق من أن axios تم استدعاؤه بشكل صحيح
        expect(mock.history.post[0].data).toEqual(
            JSON.stringify({
                number_bus: "123",
                number_passenger: "45",
            })
        );

        // التحقق من أنه تم استدعاء toast بنجاح
        expect(wrapper.vm.toast.success).toHaveBeenCalledWith(
            "Bus added successfully!"
        );
    });

    it("should handle API error gracefully", async () => {
        mock.onPost("http://127.0.0.1:8000/api/company/store_bus").reply(500);

        const wrapper = shallowMount(AddBus, { localVue, store });

        // إعداد البيانات
        await wrapper.setData({
            number_bus: "123",
            number_passenger: "45",
        });

        // تقديم النموذج
        await wrapper.find("form").trigger("submit.prevent");

        // التحقق من أن رسالة الخطأ تم عرضها بشكل صحيح
        expect(wrapper.vm.toast.error).toHaveBeenCalledWith(
            "Error adding bus."
        );
    });
});*/
