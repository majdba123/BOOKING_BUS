const AddBusModule = require("@/components/AddBus.vue");

const AddBus = AddBusModule.default || AddBusModule;

describe("AddBus.vue", () => {
    it("exposes the core bus management actions", () => {
        expect(AddBus).toBeDefined();
        expect(AddBus.methods).toBeDefined();
        expect(typeof AddBus.methods.AddBus).toBe("function");
        expect(typeof AddBus.methods.fetchBusStatus).toBe("function");
        expect(typeof AddBus.methods.openSeatsModal).toBe("function");
    });
});
