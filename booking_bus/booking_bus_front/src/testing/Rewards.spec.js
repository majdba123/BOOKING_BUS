import { shallowMount } from "@vue/test-utils";
import axios from "axios";
import Rewards from "@/components/Rewards.vue";

jest.mock("axios");

describe("Rewards.vue", () => {
    let wrapper;

    beforeEach(() => {
        wrapper = shallowMount(Rewards, {
            data() {
                return {
                    Rewards: [],
                    reward_percentage: "",
                    price: "",
                    editingIndex: null,
                    x: null,
                };
            },
        });
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    it("fetches all rewards when AllRewards is called", async () => {
        const mockData = [
            { id: 1, reward_percentage: "10%", Reservation_Costs: "100" },
            { id: 2, reward_percentage: "20%", Reservation_Costs: "200" },
        ];
        axios.get.mockResolvedValue({ data: mockData });

        await wrapper.vm.AllRewards();

        expect(axios.get).toHaveBeenCalledWith(
            "http://127.0.0.1:8000/api/company/rewards/",
            {
                headers: { Authorization: expect.any(String) },
            }
        );
        expect(wrapper.vm.Rewards).toEqual(mockData);
        expect(wrapper.vm.loading).toBe(false);
    });

    it("adds a new reward when saveChanges is called", async () => {
        const mockReward = {
            id: 3,
            reward_percentage: "15%",
            Reservation_Costs: "150",
        };
        axios.post.mockResolvedValue({ data: mockReward });

        wrapper.setData({ reward_percentage: "15%", price: "150" });
        await wrapper.vm.saveChanges();

        expect(axios.post).toHaveBeenCalledWith(
            "http://127.0.0.1:8000/api/company/rewards/store",
            { reward_percentage: "15%", Reservation_Costs: "150" },
            { headers: { Authorization: expect.any(String) } }
        );
        expect(wrapper.vm.Rewards).toContainEqual(mockReward);
        expect(wrapper.vm.reward_percentage).toBe("");
        expect(wrapper.vm.price).toBe("");
    });

    it("edits a reward when saveEditedChanges is called", async () => {
        const mockUpdatedReward = {
            id: 1,
            reward_percentage: "12%",
            Reservation_Costs: "120",
        };
        axios.put.mockResolvedValue({ data: mockUpdatedReward });

        wrapper.setData({
            reward_percentage: "12%",
            price: "120",
            editingIndex: 0,
            x: 1,
            Rewards: [
                { id: 1, reward_percentage: "10%", Reservation_Costs: "100" },
            ],
        });

        await wrapper.vm.saveEditedChanges();

        expect(axios.put).toHaveBeenCalledWith(
            `http://127.0.0.1:8000/api/company/rewards/1`,
            { reward_percentage: "12%", Reservation_Costs: "120" },
            { headers: { Authorization: expect.any(String) } }
        );
        expect(wrapper.vm.Rewards[0]).toEqual(mockUpdatedReward);
        expect(wrapper.vm.reward_percentage).toBe("");
        expect(wrapper.vm.price).toBe("");
    });
});
